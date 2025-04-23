//
//  ObservableArray.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation
import SwiftUI
import Combine

/// A class representing an observable array of items.
public class ObservableArray<T: Equatable>: ObservableObject {
    
    /// The array of data items.
    @Published private(set) public var datas: [T]
    
    /// Initializes an `ObservableArray` with an optional initial array of data.
    ///
    /// - Parameter datas: An optional array of data to initialize the `ObservableArray`.
    public init(datas: [T] = []) {
        self.datas = datas
    }
    
    /// Access an item in the array by index.
    ///
    /// - Parameter index: The index of the item to access.
    /// - Returns: The item at the specified index or nil if the index is out of bounds.
    public subscript(_ index: Int) -> T? {
        get {
            return self.datas.indices ~= index ? datas[index] : nil
        }
        set {
            if let newValue, self.datas.indices ~= index {
                self.datas[index] = newValue
            }
            self.objectWillChange.send()
        }
    }
    
    /// Append an item to the array.
    ///
    /// - Parameter item: The item to add.
    public func append(_ item: T) {
        self.datas.append(item)
        objectWillChange.send()
    }
    
    /// Append an array of items to the array.
    ///
    /// - Parameter items: An array of items to add.
    public func append(_ items: [T]) {
        self.datas.append(contentsOf: items)
        objectWillChange.send()
    }
    
    /// Insert an item at a specific index in the array.
    ///
    /// - Parameter item: The item to insert.
    /// - Parameter at: The index at which to insert the item.
    public func insert(_ item: T, at: Int) {
        self.datas.insert(item, at: at)
        objectWillChange.send()
    }
    
    /// Remove an item from the array.
    ///
    /// - Parameter item: The item to remove.
    public func remove(_ item: T) {
        self.datas = self.datas.filter({ $0 != item })
        objectWillChange.send()
    }
    
    /// Find the index of a specific item in the array.
    ///
    /// - Parameter item: The item to search for.
    /// - Returns: The index of the item in the array, or nil if not found.
    public func index(of item: T) -> Int? {
        return self.datas.firstIndex(of: item)
    }
}

