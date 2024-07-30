//
//  APIReachabilityManager.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation
/// Manager to check the Internet connection. Used before attempting to send a request.
///
/// You can use default implementation of the ReachabilityManager – **ReachabilityManagerImpl.** It is a singleton, which you can get by property shared.
public protocol APIReachabilityManager: AnyObject {
    var isInternetConnectionAvailable: Bool { get }
}
