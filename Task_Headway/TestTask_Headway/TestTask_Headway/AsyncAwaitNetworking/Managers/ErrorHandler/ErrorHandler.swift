//
//  ErrorHandler.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Combine
import Foundation

// MARK: - Typealias
public typealias NetworkingOutput = (data: Data, response: URLResponse)

/// Manager for handling Provider errors.
///
/// It contains:
/// - **ErrorType associatedtype** – the type of error the manager will work with.
/// You can use your own error type, but it must be subscribed to ErrorProtocol.
/// - **outputHandling method** – to handle the response from the server.
/// - **convert method** – to convert NSError on unsuccessful request  to ErrorType.
///
/// You can use the default implementation of the ErrorHandler – **ErrorHandlerImpl**
///
public protocol APIErrorHandler {
    /// The type of error the manager will work with.
    /// You can use your own error type, but it must be subscribed to ErrorProtocol.
    associatedtype ErrorType: ErrorProtocol
    
    /// A method for processing the response from the server. Receives server response and the retryMethod block.
    /// retryMethod can be used to retry a request after an error has been handled.
    func outputHandling(
        _ output: NetworkingOutput) async throws -> NetworkingOutput?
    
    /// Method for converting NSError on unsuccessful request  to ErrorType.
    func convert(error: NSError) -> ErrorType
}
