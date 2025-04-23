//
//  FTMovieHomeView.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import SwiftUI
import FlipTreeFoundation
import FlipTreeModels
import FlipTreeDataHandlers

/// The main view for displaying a list of movies in the FlipTree app.
struct FTMovieHomeView: View {
    
    /// Environment object for managing the app's environment.
    @EnvironmentObject var ftEnvironment: FTEnvironment
    
    /// Environment value for handling view presentation.
    @Environment(\.viewController) private var presentationHandler
    
    /// View model responsible for movie data and interactions.
    @StateObject var movieVM: FTMovieVM = .init()
    
    // MARK: - Private Variables
    
    /// Grid columns for the movie list.
    private var columns: [GridItem] {
        var items: [GridItem] = [.init(.flexible()), .init(.flexible())]
        if UIDevice.current.userInterfaceIdiom != .phone {
            items.append(.init(.flexible()))
        }
        return items
    }
    
    // MARK: - View
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if FTNetworkMonitor.shared.isNetworkAvailable {
                    LinearGradient(
                        gradient: Gradient(
                            colors: [.black, .themePrimary, .themePrimary, .themeSecondary, .white]
                        ),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                } else {
                    Color.black
                }
                movieListView()
                    .padding(.top, proxy.safeAreaInsets.top)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .task {
            if FTNetworkMonitor.shared.isNetworkAvailable {
                self.movieVM.fetchOnlineMovies(forPage: 1)
            } else {
                self.movieVM.fetchOfflineMovies()
            }
        }
    }
    
    func movieListView() -> some View {
        ScrollView {
            LazyVGrid(
                columns: self.columns,
                content: {
                    ForEach(self.movieVM.movies.datas, id: \.title) { movie in
                        cellView(for: movie)
                            .onAppear {
                                self.movieVM.shouldFetchNextPage(for: movie)
                            }
                            .onTapGesture {
                                presentationHandler?.present(style: .pageSheet, transitionStyle: .coverVertical) {
                                    FTMovieDetailView(movie: movie)
                                }
                            }
                            .id(movie.title)
                    }
                })
        }
    }
    
    func cellView(for movie: FTMovieModel) -> some View {
        MovieCellView(
            movie: movie,
            isLiked:  movieVM.isMovieLiked(movie.id),
            onLikeAction: {
                movieVM.onMovieLikeAction(movie.id)
            }
        )
    }
}

/// View for displaying individual movie cells.
struct MovieCellView: View {
    
    let movie: FTMovieModel
    @State var isLiked: Bool
    let onLikeAction: () -> Void
    
    /// Checks if the device is an iPhone.
    private var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var body: some View {
        ZStack {
            // Load an image from downloaded data, or from URL, else show a placeholder.
            if FTNetworkMonitor.shared.isNetworkAvailable, !movie.posterPath.isEmpty {
                FTImageView(.url(FlipTreeConfig.FlipTreeURLs.imageW185Base.rawValue + movie.posterPath), quality: .low)
            } else if let poster = movie.getPosterData() {
                FTImageView(.data(poster), quality: .low)
            } else {
                FTImageView(.asset("NoPoster"))
            }
            LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            FTImageView(.asset("liked"),
            color: isLiked ? nil : .white)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .alignHorizontally(.trailing)
                .alignVertically(.top)
                .padding(5)
                .padding(.top, 5)
                .onTapGesture {
                    onLikeAction()
                    isLiked.toggle()
                }
            Text(movie.title)
                .font(.subheadline)
                .foregroundColor(.white)
                .alignHorizontally(.center)
                .alignVertically(.bottom)
                .padding(5)
                .padding(.bottom, 5)
        }
        .frame(height: self.isIPhone ? 250 : 350)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding()
    }
}

struct FTMovieHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FTMovieHomeView()
    }
}

