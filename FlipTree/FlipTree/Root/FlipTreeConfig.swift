//
//  FlipTreeConfig.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation

/// A configuration class for FlipTree application settings.
final class FlipTreeConfig {
    
    /// An enumeration of FlipTree-specific URLs.
    enum FlipTreeURLs: String {
        case base = "https://api.themoviedb.org/3/discover/movie"
        case imageOriginalBase = "https://image.tmdb.org/t/p/original/"
        case imageW92Base = "https://image.tmdb.org/t/p/w92/"
        case imageW154Base = "https://image.tmdb.org/t/p/w154/"
        case imageW185Base = "https://image.tmdb.org/t/p/w185/"
        case imageW342Base = "https://image.tmdb.org/t/p/w342/"
        case imageW500Base = "https://image.tmdb.org/t/p/w500/"
        case imageW780Base = "https://image.tmdb.org/t/p/w780/"
    }
    
    /// The name of the Core Data database for the FlipTree application.
    static let CoreDBName = "FlipTreeCoreData"
    
    /// The API key for accessing external services or data.
    static let APIKey = "ed88395e5f3657d11c5f1ab378ec8e99"
}

