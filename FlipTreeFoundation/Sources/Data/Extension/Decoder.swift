//
//  File.swift
//  
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation
/*
    The main work of safe decodable to safeyly type cast from one data type to another
    Usually the response from api is tend to have different data types for same key
    some time amount could be returned as int, double or even string
    This class helps to decode without worrying about the format sent from server
    and we can store date care free to our formats.
 
 */


// MARK: - KeyedDecodingContainer

public extension KeyedDecodingContainer {

    func safeDecodeValue<T: SafeDecodable & Decodable>(forKey key: Self.Key) -> T {

        if let value = try? self.decodeIfPresent(T.self, forKey: key) {
            return value
        } else if let value = try? self.decodeIfPresent(String.self, forKey: key) {
            return value.cast()
        } else if let value = try? self.decodeIfPresent(Int.self, forKey: key) {
            return value.cast()
        } else if let value = try? self.decodeIfPresent(Float.self, forKey: key) {
            return value.cast()
        } else if let value = try? self.decodeIfPresent(Double.self, forKey: key) {
            return value.cast()
        } else if let value = try? self.decodeIfPresent(Bool.self, forKey: key) {
            return value.cast()
        }
        return T.defaultValue

    }
}

// MARK: - protocol SafeDecodable
public protocol SafeDecodable {
    static var defaultValue: Self {get}
    func cast<T: SafeDecodable>() -> T
}
// MARK: - Int
extension Int: SafeDecodable {
    public static var defaultValue: Int {return Int()}
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.defaultValue
    }

}
// MARK: - Double
extension Double: SafeDecodable {
    public static var defaultValue: Double {return Double()}
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.defaultValue
    }
}
// MARK: - Float
extension Float: SafeDecodable {
    public static var defaultValue: Float {return Float()}
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.defaultValue
    }
}
// MARK: - String
extension String: SafeDecodable {
    public static var defaultValue: String {return String()}
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is Int.Type:
            castValue = Int(self.description) as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = ["true", "yes", "1"]
                .contains(self.lowercased()) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.defaultValue
    }
}
// MARK: - Bool
extension Bool: SafeDecodable {
    public static var defaultValue: Bool {return Bool()}
    public func cast<T>() -> T where T: SafeDecodable {
        let castValue: T?
        switch T.self {
        case let x where x is String.Type:
            if self.description.lowercased() == "false"{
                castValue = "" as? T
            } else {
                castValue = self.description as? T
            }
        case let x where x is Double.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Bool.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Float.Type:
            castValue = (self ? 1 : 0) as? T
        default:
            castValue = self as? T
        }

        return castValue ?? T.defaultValue
    }
}
// MARK: - Array
extension Array: SafeDecodable {
    public static var defaultValue: [Element] {return [Element]()}
    public func cast<T>() -> T where T: SafeDecodable {
       return T.defaultValue
    }
}
