//
//  APIReachanilityManagerImp.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation
import Network

/// Default implementation of the ReachabilityManager.
///
/// It is manager to check the Internet connection. Used before attempting to send a request.
/// It is a singleton, which you can get by property shared.
public class APIReachabilityManagerImpl: APIReachabilityManager {
    // MARK: - Static Properties
    private static let queueLabel = "ReachabilityManagerQueue"
    
    // MARK: - Public Properties
    public var isInternetConnectionAvailable: Bool = {
        return false
    }()
    
    // MARK: - Private Properties
    private var connectionMonitor = NWPathMonitor()
    
    // MARK: - Singleton Init
    public static let shared = APIReachabilityManagerImpl()
    
    private init() {
        let queue = DispatchQueue(
            label: APIReachabilityManagerImpl.queueLabel
        )
        
        self.connectionMonitor.pathUpdateHandler = { pathUpdateHandler in
            self.isInternetConnectionAvailable = pathUpdateHandler.status == .satisfied
        }
        
        self.connectionMonitor.start(queue: queue)
    }
}
