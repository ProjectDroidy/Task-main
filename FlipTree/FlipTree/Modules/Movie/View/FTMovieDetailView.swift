//
//  FTMovieDetailView.swift
//  FlipTree
//
//  Created by Abishek Robin on 15/10/23.
//

import SwiftUI
import FlipTreeFoundation
import FlipTreeModels
import FlipTreeDataHandlers

/// A view for displaying detailed information about a movie in the FlipTree app.
struct FTMovieDetailView: View {
    
    /// The movie to display details for.
    let movie: FTMovieModel
    
    /// Translation value for the banner animation.
    @State private var bannerTranslation: CGFloat = 0
    
    /// Checks if the device is an iPhone.
    var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// The scale factor for elements based on the device type.
    private var scale: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .phone ? 5 : 8
    }
    
    // MARK: - View
    var body: some View {
        ZStack {
            backgroundView()
            LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            contentView()
        }
    }
    
    /// View for the background image or color based on network availability and movie backdrop path.
    @ViewBuilder
    func backgroundView() -> some View {
        if let backdropData = movie.backdropData {
            FTImageView(.data(backdropData))
                .frame(width: 300, height: 180)
                .scaleEffect(CGSize(width: scale, height: scale))
                .offset(x: self.bannerTranslation)
                .onAppear {
                    self.startAnimation()
                }
        } else {
            Color.black
        }
    }
    
    /// Main content view displaying movie details.
    func contentView() -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                Color.clear
                    .frame(height: isIPhone ? 100 : 200)
                
                if let posterData = movie.posterData {
                    FTImageView(.data(posterData))
                        .frame(width: isIPhone ? 180 : 250, height: isIPhone ? 300 : 400)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .alignHorizontally(.center)
                } else if !movie.posterPath.isEmpty {
                    FTImageView(.url(FlipTreeConfig.FlipTreeURLs.imageOriginalBase.rawValue + movie.posterPath))
                        .frame(width: 180, height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .alignHorizontally(.center)
                } else {
                    Color.clear
                        .frame(height: 300)
                }
                
                Text(movie.title)
                    .font(.title)
                    .foregroundColor(.white)
                
                ScrollView(.horizontal) {
                    HStack {
                        capsuleView(text: movie.releaseDate)
                        capsuleView(text: "Rating: " + movie.voteAverage.description)
                        capsuleView(text: "Popularity: " + movie.popularity.description)
                        capsuleView(text: "Votes: " + movie.voteCount.description)
                    }
                }
                
                Text(movie.overview)
                    .font(.callout)
                    .foregroundColor(.white)
            }.padding(.horizontal, 20)
        }
    }
    
    /// View for displaying information in a capsule-shaped container.
    func capsuleView(text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(5)
            .padding(.horizontal, 3)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 4)
    }
    
    // MARK: - Animation
    
    /// Start the banner animation.
    func startAnimation() {
        withAnimation(Animation.linear(duration: 4).repeatForever()) {
            self.bannerTranslation = 100
        }
    }
}

