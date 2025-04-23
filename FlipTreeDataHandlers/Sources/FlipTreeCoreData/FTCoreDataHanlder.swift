//
//  FTCoreDataHandler.swift
//
//
//  Created by [Author Name] on [Date].
//

import Foundation
import CoreData
import FlipTreeFoundation
import FlipTreeModels

/// Enum representing custom CoreData-related errors.
public enum FTCoreDataError: Error {
    case JSONSerialization
}

extension FTCoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .JSONSerialization:
            return "Failed JSON Serialization"
        }
    }
}

/// Generic class for handling CoreData operations with a specific Entity type.
///
/// This class provides functionality for interacting with Core Data and managing entities of a specific type.
///   - Core Data DB should be located in the base project, not in packages.
///   - CoreData Entity should be named following the convention [ModelName]Entity, and the corresponding Object should have the name [ModelName]Model (e.g., FTMovieEntity & FTMovieModel).
///	
/// Usage:
/// ```swift
/// // Example usage to create an instance of FTCoreDataHandler:
/// let coreDataHandler = FTCoreDataHandler<FTMovieEntity>()
/// ```
public class FTCoreDataHandler<Entity: FTCoreDataProtocol>: ObservableObject {
    
    // MARK: - Local Variables
    
    private let container: NSPersistentContainer
    
    // MARK: - Initializers
    
    /// Initialize the CoreData handler with a specific database name.
    ///
    /// - Parameter dbName: The name of the CoreData database.
    public init(with dbName: String) {
        let container = NSPersistentContainer(name: dbName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        self.container = container
    }
    
    // MARK: - Private Methods
    
    /// Retrieve the NSEntityDescription for the specified Entity type.
    ///
    /// - Returns: The NSEntityDescription object or nil if not found.
    private func getEntity() -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: Entity.EntityName, in: container.viewContext)
    }
    
    /// Save a managed object to CoreData.
    ///
    /// - Parameter object: The NSManagedObject to save.
    private func saveEntity(_ object: NSManagedObject) {
        do {
            try object.managedObjectContext?.save()
        } catch {
            print("CoreData save failed for entity: \(object.description)")
        }
    }
    
    // MARK: - Public Methods
    
    /// Delete all data of the Entity type from CoreData.
    ///
    /// - Throws: An error if the data deletion fails.
    public func deleteAllData() throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.EntityName)
        request.returnsObjectsAsFaults = false
        let result = try self.container.viewContext.fetch(request)
        result.compactMap({
            $0 as? NSManagedObject
        }).forEach({
            container.viewContext.delete($0)
        })
    }
    /// Deletes a single `NSManagedObject` from Core Data.
    ///
    /// - Parameter object: The `NSManagedObject` instance to delete.
    /// - Throws: An error if the deletion or save fails.
    public func delete(_ data: Entity) throws {
        guard let entity = self.getEntity() else { return }
        let object: NSManagedObject
        if let uniqueID = data.id,
           let existingEntity = try findEntity(byId: uniqueID){
            object = existingEntity
        }else{
            object = .init(entity: entity, insertInto: self.container.viewContext)
        }
        let context = container.viewContext
        context.delete(object)
        try context.save()
    }


    /// Store data of the Entity type in CoreData. (If unique id is available, will update)
    ///
    /// - Parameter data: The data to be stored.
    ///
    /// - Throws: An error if storing the data fails, including JSON serialization errors.
    public func storeData(_ data: Entity) throws {
        guard let entity = self.getEntity() else { return }
        let object: NSManagedObject
        if let uniqueID = data.id,
           let existingEntity = try findEntity(byId: uniqueID){
            object = existingEntity
        }else{
            object = .init(entity: entity, insertInto: self.container.viewContext)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(data)
        guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JSON else {
            throw FTCoreDataError.JSONSerialization
        }
        for (key, value) in jsonObject {
            object.setValue(value, forKey: key)
        }
        self.saveEntity(object)
    }
    
    // Helper method to find an entity by its "id" property.
    private func findEntity(byId id: Int) throws -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.EntityName)
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        return try self.container.viewContext.fetch(request).first as? NSManagedObject
    }
    /// Fetch all data of the Entity type from CoreData.
    ///
    /// - Returns: An array of entities fetched from CoreData.
    ///
    /// - Throws: An error if fetching or JSON decoding fails.
    public func fetchAllData() throws -> [Entity] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.EntityName)
        request.returnsObjectsAsFaults = false
        let result = try self.container.viewContext.fetch(request)
        return try result.compactMap({
            $0 as? NSManagedObject
        }).compactMap({
            let json: JSON = $0.dictionaryWithValues(forKeys: Array($0.entity.attributesByName.keys))
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            let decoder = JSONDecoder()
            return try decoder.decode(Entity.self, from: jsonData)
        })
    }
    // Helper method to find an data by its "id" property.
    public func findData(byId id: Int) throws -> Entity?{
        guard let entity = try self.findEntity(byId: id) else{return nil}
        
        let json: JSON = entity.dictionaryWithValues(forKeys: Array(entity.entity.attributesByName.keys))
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        let decoder = JSONDecoder()
        return try decoder.decode(Entity.self, from: jsonData)
    }
}

