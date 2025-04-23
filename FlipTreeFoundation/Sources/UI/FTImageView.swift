//
//  FTImageView.swift
//  FlipTree
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation
import SwiftUI
import Combine

/// An enumeration of possible system icon names.
public enum SystemIconName: String {
    case drop
}

/// A view for displaying images from different sources.
public struct FTImageView: View {
    public enum Input: Hashable {
        case system(_ name: SystemIconName)
        case asset(_ name: String)
        case url(_ str: String)
        case data(_ data: Data)
    }
    
    public var input: Input
    public var color: Color?
    private var quality: Image.Interpolation
    
    @StateObject private var downloader = ImageDownloader()
    
    /// Initializes an `FTImageView` with the specified input and optional parameters.
    ///
    /// - Parameters:
    ///   - input: The source of the image (system icon, asset, URL, or data).
    ///   - color: The color to apply to the image (optional).
    ///   - quality: The interpolation quality for the image (default is .high).
    public init(_ input: Input, color: Color? = nil, quality: Image.Interpolation = .high) {
        self.input = input
        self.color = color
        self.quality = quality
    }
    
    public var body: some View {
        if let givenColor = color {
            image
                .interpolation(self.quality)
                .renderingMode(.template)
                .foregroundColor(givenColor)
        } else {
            image
                .interpolation(self.quality)
        }
    }
    
    private var image: Image {
        switch input {
        case .asset(let iconName):
            return Image(iconName).resizable()
        case .system(let systemName):
            return Image(systemName: systemName.rawValue).resizable()
        case .url(let string):
            if let url = URL(string: string) {
                downloader.loadImageFromUrl(url)
            }
            return Image(uiImage: downloader.image).resizable()
        case .data(let data):
            return Image(uiImage: UIImage(data: data) ?? UIImage()).resizable()
        }
    }
}

/// A class for downloading and caching images.
private class ImageDownloader: ObservableObject {
    @Published var image: UIImage = UIImage()
    var cache = NSCache<NSString, UIImage>()
    private var urlString: String?
    
    /// Loads an image from the specified URL.
    ///
    /// - Parameter url: The URL of the image to load.
    func loadImageFromUrl(_ url: URL) {
        self.urlString = url.absoluteString
        if let image = self.cache.object(forKey: NSString(string: self.urlString!)) {
            DispatchQueue.main.async {
                self.image = image
            }
        } else {
            let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
            task.resume()
        }
    }
    
    /// Handles the response data from the URL request and updates the image.
    ///
    /// - Parameters:
    ///   - data: The data received from the URL request.
    ///   - response: The URL response.
    ///   - error: Any error that occurred during the request.
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            debugPrint("Error: \(error!)")
            return
        }
        guard let data = data else {
            debugPrint("No data found")
            return
        }
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.image = loadedImage
            self.cache.setObject(loadedImage, forKey: NSString(string: self.urlString!))
        }
    }
}

