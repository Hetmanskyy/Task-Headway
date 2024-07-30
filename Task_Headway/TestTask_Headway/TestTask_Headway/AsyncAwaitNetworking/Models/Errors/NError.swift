//
//  NError.swift
//  TestTask_Headway

import Foundation

/// Default implementation of the ErrorProtocol.
public enum APIError: ErrorProtocol {
    case badURLError
    case timedOutError
    case hostError
    case tooManyRedirectsError
    case resourceUnavailable
    case reachabilityError
    case decodingError
    case clientError
    case serverError
    case unspecifiedError
    
    var description: String? {
        switch self {
        case .badURLError:
            return "Bad URL Error. Please try again later."
        case .timedOutError:
            return "Timed Out Error. Please check your internet connection."
        case .hostError:
            return "Host Error. Please try again later."
        case .tooManyRedirectsError:
            return "Too Many Redirects. Please try again later."
        case .resourceUnavailable:
            return "Resource Unavailable. Please try again later."
        case .reachabilityError:
            return "Internet connection problem. Please check your internet connection."
        case .decodingError:
            return "We were unable to identify the data that came from the server. Please try again later."
        case .clientError:
            return "An error occurred on the client side. Please try again later."
        case .serverError:
            return "An error occurred on the server side. Please try again later."
        case .unspecifiedError:
            return "For unknown reasons, something went wrong. Please try again later."
        }
    }
}