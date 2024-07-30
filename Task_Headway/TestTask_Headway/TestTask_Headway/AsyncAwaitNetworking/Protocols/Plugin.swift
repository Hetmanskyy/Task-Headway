//
//  Plugin.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation

/// Object protocol for request modification.
///
/// Most often you will use it to customize request headers.
/// An array of such objects is passed to Provider, and taken into account when creating a request in RequestBuilder.
public protocol Plugin {
    func modifyRequest(_ request: inout URLRequest)
}

