//
//  FatalError.swift
//  TestTask_Headway

import Foundation
enum FatalError: Error {
    case pathIncorrect(_ path: String)
    case pathOrQueryIncorrect(_ path: String, _ query: QueryItems)
    
    var description: String {
        switch self {
        case .pathIncorrect(let path):
            return "Path is incorrect: \(path)"
            
        case .pathOrQueryIncorrect(let path, let query):
            return "URL with path: \(path) and query items:\n\(query)\nis incorrect"
        }
    }
}
