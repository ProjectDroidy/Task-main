//
//  FlipTreeApp.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import SwiftUI
import FlipTreeDataHandlers

/// The main entry point of the FlipTree application.
@main
struct FlipTreeApp: App {
    
    /// The state object responsible for managing the application's environment.
    @StateObject var ftEnvironment = FTEnvironment()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(ftEnvironment)
                .onAppear {
                    // Start monitoring network connectivity when the app appears.
                    FTNetworkMonitor.shared.startMonitoring()
                }
        }
    }
}

