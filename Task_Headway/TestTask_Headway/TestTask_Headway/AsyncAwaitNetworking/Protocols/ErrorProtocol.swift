//
//  ErrorProtocol.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation

/// The protocol to which any custom error type that can communicate with the Provider must be subscribed.
///
/// Includes mandatory errors such as:
/// - **reachabilityError** – related to the reachability of the network.
/// - **decodingError** – related to data decoding to the object.
/// - **unspecifiedError** – associated with cases that are not part of the processed cases.
///
/// You can use the default implementation of this protocol - Error
///
public protocol ErrorProtocol: Error {
    static var reachabilityError: Self { get }
    static var decodingError: Self { get }
    static var unspecifiedError: Self { get }
    static var badURLError: Self { get }
    static var timedOutError: Self { get }
    static var tooManyRedirectsError: Self { get }
    static var resourceUnavailable: Self { get }
    static var clientError: Self { get }
    static var serverError: Self { get }
}
