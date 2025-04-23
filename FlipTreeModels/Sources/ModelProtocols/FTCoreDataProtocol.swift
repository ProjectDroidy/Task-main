// FTCoreDataProtocol.swift
// FlipTree
//
// Created by Abishek Robin on [Date]

import FlipTreeFoundation
import CoreData

/// A protocol for objects that can be stored in Core Data and encoded/decoded.
public protocol FTCoreDataProtocol: Codable {
    
    /// An optional identifier for the object.
    var id: Int? { get }
    
    /// The name of the Core Data entity associated with the conforming type.
    static var EntityName: String { get }
}

public extension FTCoreDataProtocol {
    
    /// The default implementation for EntityName property.
    ///
    /// By default, it creates the entity name based on the conforming type's name.
    /// It replaces "Model" with "Entity" and removes ".Type" if they are part of the type name.
    static var EntityName: String {
        return String(describing: type(of: self))
            .replacingOccurrences(of: "Model", with: "Entity")
            .replacingOccurrences(of: ".Type", with: "")
    }
}

