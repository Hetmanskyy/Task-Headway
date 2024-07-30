//
//  ProviderProtocol.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation
public protocol ProviderProtocol {
    /// Type of object subscribed to the **RequestBuilder** protocol.
    /// Responsible for describing and creating the URLRequest object.
    associatedtype RequestBuilder: APIRequestBuilder
    
    /// The object type subscribed to the **ErrorHandler** protocol.
    /// Responsible for handling errors received in Provider.
    /// If necessary, you can use a ready-made implementation - ErrorHandlerImpl, or create your own.
    associatedtype ErrorHandler: APIErrorHandler
    
    /// Base URL where the request will be made.
    var baseURL: URL { get }
    
    /// Manager to check the Internet connection.
    /// Used before attempting to send a request.
    var reachability: APIReachabilityManager { get }
    
    /// URLSession with which the request will be executed
    var session: URLSession { get }
    
    /// Responsible for handling errors received in Provider.
    var errorHandler: ErrorHandler { get }
    
    /// Array with objects for request modification.
    ///
    /// Most often you will use it to customize request headers.
    var plugins: [Plugin] { get }
    
    /// JSONDecoder with which the object will be decoded.
    var decoder: JSONDecoder { get }
}
