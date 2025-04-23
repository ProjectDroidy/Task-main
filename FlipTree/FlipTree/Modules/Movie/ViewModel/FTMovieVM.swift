//
//  FTMovieVM.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation
import FlipTreeFoundation
import FlipTreeModels
import FlipTreeDataHandlers

/// View model for managing movie data and API calls.
class FTMovieVM: ObservableObject {
    
    // MARK: - Core Data and API Handlers
    
    /// Core Data handler for movie data storage.
    let movieCoreDataHandler: FTCoreDataHandler<FTMovieModel>
    let likedMovieCoreDataHandler: FTCoreDataHandler<FTLikedMovieModel>
    
    /// API handler for making network requests.
    let apiHandler: FTAPIHandler
    
    // MARK: - Private Data
    
    private var currentPage = 0
    private var loadingPage: Int? = nil
    
    // MARK: - Published Data
    
    @Published
    var movies = ObservableArray<FTMovieModel>()
    
    // MARK: - Initializer
    
    init() {
        self.movieCoreDataHandler = .init(with: FlipTreeConfig.CoreDBName)
        self.likedMovieCoreDataHandler = .init(with: FlipTreeConfig.CoreDBName)
        self.apiHandler = .init()
    }
    
    /// Checks if the next page of data should be fetched when scrolling.
    func shouldFetchNextPage(for movie: FTMovieModel) {
        guard loadingPage == nil else { return }
        if self.movies.datas.last == movie {
            self.fetchOnlineMovies(forPage: currentPage + 1)
        }
    }
    
    // MARK: - API Calls
    
    /// Fetches movies from an online source for a given page.
    func fetchOnlineMovies(forPage page: Int) {
        self.loadingPage = page
        let params: JSON = [
            "api_key": FlipTreeConfig.APIKey,
            "include_adult": "false",
            "include_video": "false",
            "language": "en-US",
            "page": page.description,
            "sort_by": "popularity.desc",
        ]
        
        Task {
            let response = await self.apiHandler.asyncResponseForRequest(
                from: FlipTreeConfig.FlipTreeURLs.base.rawValue,
                param: params,
                method: .get,
                model: MoviePageModel.self)
            
            switch response {
            case .success(let result):
                let movies = result.results
                self.currentPage = result.page
                self.loadingPage = nil
                await self.storeMovies(movies)
                await self.appendMoviesToDisplay(movies)
            case .failure(let error):
                self.loadingPage = nil
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func appendMoviesToDisplay(_ movies: [FTMovieModel]) {
        for movie in movies {
            if let index = self.movies.index(of: movie) {
                self.movies.remove(movie)
                self.movies.insert(movie, at: index)
            } else {
                self.movies.append(movie)
            }
        }
        self.objectWillChange.send()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadImages(for: movies)
        }
    }
    
    // MARK: - Core Data Methods
    
    @MainActor
    func storeMovies(_ movies: [FTMovieModel]) {
        do {
            try movies.forEach({
                try movieCoreDataHandler.storeData($0)
            })
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchOfflineMovies() {
        do {
            let movies = try self.movieCoreDataHandler.fetchAllData()
            print(movies.count)
            self.movies.append(movies)
            self.objectWillChange.send()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func onMovieLikeAction(_ movieId: Int?) {
        guard let movieId else {return }
        do {
            if let likedMovie = try likedMovieCoreDataHandler.findData(byId: movieId){
                try likedMovieCoreDataHandler.delete(likedMovie)
            }else{
                try likedMovieCoreDataHandler.storeData(FTLikedMovieModel(movieId: movieId))
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func isMovieLiked(_ movieId: Int?) -> Bool {
        guard let movieId else {return false}
        do {
            if let _ = try likedMovieCoreDataHandler.findData(byId: movieId){
                return true
            }else{
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    // MARK: - Loading Banners and Posters
    
    func loadImages(for movies: [FTMovieModel]) {
        Task {
            do {
                for movie in movies {
                    let poster = try await self.apiHandler.asyncRequest(
                        from: FlipTreeConfig.FlipTreeURLs.imageW185Base.rawValue + movie.posterPath,
                        method: .get
                    )
                    let banner = try await self.apiHandler.asyncRequest(
                        from: FlipTreeConfig.FlipTreeURLs.imageOriginalBase.rawValue + movie.backdropPath,
                        method: .get
                    )
                    
                    movie.posterData = poster
                    movie.backdropData = banner
                }
                Task {
                    await self.storeMovies(movies)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

