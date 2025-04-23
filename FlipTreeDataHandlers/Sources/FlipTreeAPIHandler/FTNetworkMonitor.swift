//
//  FTNetworkMonitor.swift
//  FlipTree
//
//  Created by Abishek Robin on 15/10/23.
//

import Foundation
import Network

/// A singleton class for monitoring network connectivity.
public final class FTNetworkMonitor {
    
    /// The shared instance of the network monitor.
    public static let shared = FTNetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    /// A boolean indicating whether the network is currently available.
    public var isNetworkAvailable: Bool = false

    private init() {
        monitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
    }
    
    /// Start monitoring the network status.
    public func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    /// Stop monitoring the network status.
    public func stopMonitoring() {
        monitor.cancel()
    }
}

