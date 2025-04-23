//
//  FTAPIHandler.swift
//
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation

/// Enum representing HTTP methods.
public enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Custom error type for API-related errors.
public enum FTAPIError: Error {
    case JSONError
    case URLParseError
}

/// Class for handling API requests.
public class FTAPIHandler {
    
    private let manager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 100000
        configuration.timeoutIntervalForResource = 100000
        return URLSession(configuration: configuration)
    }()
    
    public init() {
        // Initialization code can be added here if needed.
    }
    
    // MARK: - Prepare Request
    
    /// Create and return a URL request with the given parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint URL.
    ///   - params: A dictionary of parameters to include in the request.
    ///   - method: The HTTP method to use for the request.
    ///
    /// - Returns: An optional URLRequest or nil if URL creation fails.
    private func prepareRequest(for endpoint: String, params: [String: Any], method: APIMethod) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint) else {
            return nil
        }
        if method == .get {
            urlComponents.queryItems = params.compactMap({ param -> URLQueryItem in
                return URLQueryItem(name: param.key, value: param.value as? String ?? "")
            })
        }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        urlRequest.httpMethod = method.rawValue
        
        if method != .get {
            let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = bodyData
        }
        
        return urlRequest
    }
    
    // MARK: - Process Response
    
    /// Asynchronously load data with the given request.
    private func asyncLoadData(with request: URLRequest) async throws -> Data {
        do {
            let (data, _) = try await manager.data(for: request)
            return data
        } catch (let error) {
            throw error
        }
    }
    
    /// Asynchronously perform an API request.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint URL.
    ///   - param: A dictionary of parameters to include in the request.
    ///   - method: The HTTP method to use for the request.
    ///
    /// - Returns: Asynchronously returns the response data.
    public
    func asyncRequest(from endpoint: String, param: [String: Any] = [:], method: APIMethod) async throws -> Data {
        guard let request = prepareRequest(for: endpoint, params: param, method: method) else {
            throw FTAPIError.URLParseError
        }
        
        let loadedRequest = try await asyncLoadData(with: request)
        
        return loadedRequest
    }
    
    /// Decode and return a Codable object from the response data.
    private func getAsyncResultFromResponse<Model: Codable>(_ response: Data, for item: Model.Type) async throws -> Model {
        let decoder = JSONDecoder()
        return try decoder.decode(Model.self, from: response)
    }
    
    // MARK: - Public Accessible Methods
    
    /// Asynchronously send an API request and return the result.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint URL.
    ///   - param: A dictionary of parameters to include in the request.
    ///   - method: The HTTP method to use for the request.
    ///   - model: The Codable model type to decode the response into.
    ///
    /// - Returns: An asynchronous Result containing either the decoded model or an error.
    public func asyncResponseForRequest<Model: Codable>(from endpoint: String, param: [String: Any] = [:], method: APIMethod, model: Model.Type) async -> Result<Model, Error> {
        do {
            let response = try await self.asyncRequest(from: endpoint, param: param, method: method)
            let result = try await self.getAsyncResultFromResponse(response, for: model)
            return .success(result)
        } catch let error as FTAPIError {
            return .failure(error)
        } catch {
            return .failure(error)
        }
    }
}

