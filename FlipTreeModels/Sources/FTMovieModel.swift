//
//  MoviePageModel.swift
//  YourApp
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation
import CoreData
import FlipTreeFoundation

// MARK: - MoviePageModel
public class MoviePageModel: Codable {
    public let page: Int
    public let results: [FTMovieModel]
    public let totalPages, totalResults: Int

    // Coding keys for decoding JSON
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    /// Initializes a MoviePageModel from a decoder.
    ///
    /// - Parameter decoder: The decoder used for decoding JSON.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = container.safeDecodeValue(forKey: .page)
        self.results = container.safeDecodeValue(forKey: .results)
        self.totalPages = container.safeDecodeValue(forKey: .totalPages)
        self.totalResults = container.safeDecodeValue(forKey: .totalResults)
    }
}

// MARK: - MovieModel
public class FTMovieModel: FTCoreDataProtocol {
    
    public let adult: Bool
    public let backdropPath: String
    public let id: Int?
    public let originalLanguage: String
    public let originalTitle, overview: String
    public let popularity: Double
    public let posterPath, releaseDate, title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int
    public var posterData: Data?
    public var backdropData: Data?

    // Coding keys for decoding and encoding JSON
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterData = "poster_data"
        case backdropData = "backdrop_data"
    }

    /// Initializes an FTMovieModel from a decoder.
    ///
    /// - Parameter decoder: The decoder used for decoding JSON.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = container.safeDecodeValue(forKey: .adult)
        self.backdropPath = container.safeDecodeValue(forKey: .backdropPath)
        self.id = container.safeDecodeValue(forKey: .id)
        self.originalLanguage = container.safeDecodeValue(forKey: .originalLanguage)
        self.originalTitle = container.safeDecodeValue(forKey: .originalTitle)
        self.overview = container.safeDecodeValue(forKey: .overview)
        self.popularity = container.safeDecodeValue(forKey: .popularity)
        self.posterPath = container.safeDecodeValue(forKey: .posterPath)
        self.releaseDate = container.safeDecodeValue(forKey: .releaseDate)
        self.title = container.safeDecodeValue(forKey: .title)
        self.video = container.safeDecodeValue(forKey: .video)
        self.voteAverage = container.safeDecodeValue(forKey: .voteAverage)
        self.voteCount = container.safeDecodeValue(forKey: .voteCount)
        self.posterData = try container.decodeIfPresent(Data.self, forKey: .posterData)
        self.backdropData = try container.decodeIfPresent(Data.self, forKey: .backdropData)
    }

    /// Encodes the FTMovieModel to a given encoder.
    ///
    /// - Parameter encoder: The encoder used for encoding.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.adult, forKey: .adult)
        try container.encode(self.backdropPath, forKey: .backdropPath)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.originalLanguage, forKey: .originalLanguage)
        try container.encode(self.originalTitle, forKey: .originalTitle)
        try container.encode(self.overview, forKey: .overview)
        try container.encode(self.popularity, forKey: .popularity)
        try container.encode(self.posterPath, forKey: .posterPath)
        try container.encode(self.releaseDate, forKey: .releaseDate)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.video, forKey: .video)
        try container.encode(self.voteAverage, forKey: .voteAverage)
        try container.encode(self.voteCount, forKey: .voteCount)
        try container.encode(self.posterData, forKey: .posterData)
        try container.encode(self.backdropData, forKey: .backdropData)
    }

    /// Converts the original language to an OriginalLanguage enum.
    public var originalLanguageValue: OriginalLanguage? {
        return .init(rawValue: self.originalLanguage)
    }
    
    @MainActor public
    func getPosterData() -> Data?{
        return self.posterData
    }
    @MainActor public
    func getBannerData() -> Data?{
        return self.backdropData
    }
}

extension FTMovieModel: Equatable {
    public static func == (lhs: FTMovieModel, rhs: FTMovieModel) -> Bool {
        return lhs.id == rhs.id
    }
}

public enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case pt = "pt"
}

