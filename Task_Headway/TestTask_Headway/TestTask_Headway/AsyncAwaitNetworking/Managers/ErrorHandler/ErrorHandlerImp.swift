//
//  ErrorHandlerImp.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation
import Combine

public struct ErrorHandlerImpl: APIErrorHandler {
    public func outputHandling(_ output: NetworkingOutput) async throws -> NetworkingOutput? {
        
        guard let httpResponse = output.response as? HTTPURLResponse else {
            throw APIError.unspecifiedError
        }
        
        switch httpResponse.statusCode {
        case 200...399:
            return output
        case 400...499:
            throw APIError.clientError
            
        case 500...599:
            throw APIError.serverError
            
        default:
            throw APIError.unspecifiedError
        }
    }
    
    /// Method for converting APIError on unsuccessful request  to ErrorType.
    public func convert(error: NSError) -> APIError {
        switch error.code {
        case NSURLErrorBadURL:
            return .badURLError
            
        case NSURLErrorTimedOut:
            return .timedOutError
            
        case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
            return .hostError
            
        case NSURLErrorHTTPTooManyRedirects:
            return .tooManyRedirectsError
            
        case NSURLErrorResourceUnavailable:
            return .resourceUnavailable
            
        case NSURLErrorNotConnectedToInternet, NSURLErrorCallIsActive,
            NSURLErrorNetworkConnectionLost, NSURLErrorDataNotAllowed:
            return .reachabilityError
            
        default: return .unspecifiedError
        }
    }
}

