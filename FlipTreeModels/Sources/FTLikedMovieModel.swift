//
//  File.swift
//  FlipTreeModels
//
//  Created by Abishek Robin on 23/04/25.
//

import Foundation


// MARK: - FTLikedMovieModel
public class FTLikedMovieModel: FTCoreDataProtocol {
    
    public var id: Int?
    
    // Coding keys for decoding and encoding JSON
    enum CodingKeys: String, CodingKey {
        case id 
    }
    
    /// Initializes an FTMovieModel from a decoder.
    ///
    /// - Parameter decoder: The decoder used for decoding JSON.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
    }
    
    /// Encodes the FTMovieModel to a given encoder.
    ///
    /// - Parameter encoder: The encoder used for encoding.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
    }
    /// Designated initializer
       public init(movieId: Int?) {
           self.id = movieId
       }
}

extension FTLikedMovieModel: Equatable {
    public static func == (lhs: FTLikedMovieModel, rhs: FTLikedMovieModel) -> Bool {
        return lhs.id == rhs.id
    }
}
