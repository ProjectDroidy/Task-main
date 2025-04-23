//
//  FTSplashView.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import SwiftUI
import AVKit
import FlipTreeFoundation
import FlipTreeModels

/// A view displaying the splash screen with video background and app logo.
struct FTSplashView: View {
    
    /// An environment object to manage the application's environment.
    @EnvironmentObject var ftEnvironment: FTEnvironment
    
    /// The AVPlayer for the video background.
    @State var player: AVPlayer?
    
    /// The URL of the video resource in the app bundle.
    let videoURL = Bundle.main.url(forResource: "movie", withExtension: "mp4")!
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player) {
                // You can add any other view elements on top of the video here
                Color.clear
            }
            .scaleEffect(
                CGSize(width: 1.4, height: 1.4),
                anchor: .center
            )
            
            Color.white.opacity(0.1)
            
            Button(action: {
                self.ftEnvironment.sessionStarted.toggle()
            }) {
                Text("Browse Movies")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .alignView(.bottom)
            .padding(.bottom, 50)
            
            FTImageView(.asset("AppLogo"))
                .frame(width: 120, height: 120)
                .cornerRadius(10)
                .shadow(radius: 3)
                .alignView(.center)
        }
        .onAppear {
            player = AVPlayer(url: videoURL)
            player?.isMuted = true
            player?.play()
            player?.actionAtItemEnd = .none
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { _ in
                guard !self.ftEnvironment.sessionStarted else { return }
                player?.seek(to: .zero)
                player?.play()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct FTSplashView_Previews: PreviewProvider {
    static var previews: some View {
        FTSplashView()
            .environmentObject(FTEnvironment())
    }
}

