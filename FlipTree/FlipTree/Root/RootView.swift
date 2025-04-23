//
//  RootView.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import SwiftUI
import FlipTreeFoundation
import FlipTreeModels

/// The root view of the FlipTree application, determining the initial screen to display.
struct RootView: View {
    
    /// An environment object to manage the application's environment.
    @EnvironmentObject var ftEnvironment: FTEnvironment
    
    var body: some View {
        if ftEnvironment.sessionStarted {
            // Display the movie home view when a session has started.
            FTMovieHomeView()
        } else {
            // Display the splash view when no session has started.
            FTSplashView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(FTEnvironment())
    }
}

