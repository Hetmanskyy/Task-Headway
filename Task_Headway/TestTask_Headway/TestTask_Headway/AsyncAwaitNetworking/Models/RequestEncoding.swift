//
//  RequestEncoding.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation
public enum RequestEncoding {

    /// The JSON Accept/Content-Type encoding.
    case json

    /// The Form-URLEncoded Accept/Content-Type encoding.
    case form

    /// The JSON text/html Accept/Content-Type encoding.
    case textHTML
    
    case imageJPEG
    
    var headerString: String {
        switch self {

        case .json:
            return "application/json"

        case .form:
            return "application/x-www-form-urlencoded; charset=utf-8; v=2"

        case .textHTML:
            return "text/html"
            
        case .imageJPEG:
            return "image/jpeg"
        }
    }
}
