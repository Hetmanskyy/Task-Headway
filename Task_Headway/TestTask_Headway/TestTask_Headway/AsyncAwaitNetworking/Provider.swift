//
//  Provider.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation
import Combine

/// A class that serves as a provider to run requests to the server.
/// This is an implementation of the ProviderProtocol.
///
/// Contains associatedtypes:
/// - **RequestBuilder** - type of object subscribed to the **RequestBuilder** protocol.
/// Responsible for describing and creating the URLRequest object.
/// - **ErrorHandler** - the object type subscribed to the **ErrorHandler** protocol.
/// Responsible for handling errors received in Provider.
/// If necessary, you can use a ready-made implementation - ErrorHandlerImpl, or create your own.
///

final public class Provider<RequestBuilder: APIRequestBuilder, ErrorHandler: APIErrorHandler>: ProviderProtocol {
    // MARK: - Public Properties
    /// Base URL where the request will be made.
    public var baseURL: URL
    
    /// Manager to check the Internet connection.
    /// Used before attempting to send a request.
    public var reachability: APIReachabilityManager
    
    /// URLSession with which the request will be executed
    public var session: URLSession
    
    /// Responsible for handling errors received in Provider.
    public var errorHandler: ErrorHandler
    
    /// Array with objects for request modification.
    ///
    /// Most often you will use it to customize request headers.
    public var plugins: [Plugin]
    
    /// JSONDecoder with which the object will be decoded.
    public var decoder: JSONDecoder
    
    // MARK: - Init
    public init(
        baseURL: URL,
        reachability: APIReachabilityManager = APIReachabilityManagerImpl.shared,
        session: URLSession = .shared,
        requestBuilder: APIRequestBuilder.Type,
        plugins: [Plugin] = [],
        decoder: JSONDecoder = JSONDecoder()
    ) where ErrorHandler == ErrorHandlerImpl {
        
        self.baseURL = baseURL
        self.reachability = reachability
        self.session = session
        self.errorHandler = ErrorHandlerImpl()
        self.plugins = plugins
        self.decoder = decoder
    }
    
    public required init(
        baseURL: URL,
        reachability: APIReachabilityManager = APIReachabilityManagerImpl.shared,
        session: URLSession = .shared,
        errorHandler: ErrorHandler,
        requestBuilder: APIRequestBuilder.Type,
        plugins: [Plugin] = [],
        decoder: JSONDecoder = JSONDecoder()
    ) {
        
        self.baseURL = baseURL
        self.reachability = reachability
        self.session = session
        self.errorHandler = errorHandler
        self.plugins = plugins
        self.decoder = decoder
    }
}

// MARK: - Public Methods
extension Provider {
    func generalPerform(builder: RequestBuilder) async throws -> Data {
        guard reachability.isInternetConnectionAvailable else {
            throw ErrorHandler.ErrorType.reachabilityError
        }
        
        let request = builder.makeRequest(baseURL: baseURL, plugins: plugins)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ErrorHandler.ErrorType.badURLError
        }
        
        Provider.log(response: httpResponse, data: data, error: nil)
        
        if let output = try await errorHandler.outputHandling((data, response)) {
            LogManager.log(output)
            return data
        } else {
            throw ErrorHandler.ErrorType.unspecifiedError
        }
    }
    
    func send(builder: RequestBuilder) async throws {
        do {
            let _ = try await generalPerform(builder: builder)
        } catch {
            throw ErrorHandler.ErrorType.serverError
        }
    }
    
    func send<T: Decodable>(builder: RequestBuilder) async throws -> T where T: Decodable {
        do {
            let data = try await generalPerform(builder: builder)
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                // TO DO: - remove when not needed //
                debugPrint("\(parsedData)")
                return parsedData
            } catch {
                debugPrint("\(error)")
                throw ErrorHandler.ErrorType.decodingError
            }
        } catch {
            throw ErrorHandler.ErrorType.serverError
        }
    }
    
    static func log(response: HTTPURLResponse?, data: Data?, error: Error?) {
       print("\n - - - - - - - - - - INCOMMING - - - - - - - - - - \n")
       defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
       let urlString = response?.url?.absoluteString
       let components = NSURLComponents(string: urlString ?? "")
       let path = "\(components?.path ?? "")"
       let query = "\(components?.query ?? "")"
       var output = ""
       if let urlString = urlString {
          output += "\(urlString)"
          output += "\n\n"
       }
       if let statusCode =  response?.statusCode {
          output += "HTTP \(statusCode) \(path)?\(query)\n"
       }
       if let host = components?.host {
          output += "Host: \(host)\n"
       }
       for (key, value) in response?.allHeaderFields ?? [:] {
          output += "\(key): \(value)\n"
       }
       if let body = data {
          output += "\n\(String(data: body, encoding: .utf8) ?? "")\n"
       }
       if error != nil {
          output += "\nError: \(error!.localizedDescription)\n"
       }
       print(output)
    }
}
