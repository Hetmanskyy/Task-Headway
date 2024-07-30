//
//  AudioGenerationAPIBuilder.swift
//  TestTask_Headway
//
//  Created by user on 27.07.2024.
//

import Foundation

enum AudioGenerationAPIBuilder: APIRequestBuilder {
    case textToSpeechGoogle(text: String, apiKey: String)
    case downloadTheBook(url: String)
   
    
    var path: String {
        switch self {
        case .textToSpeechGoogle:
            return "/v1/text:synthesize"
        case .downloadTheBook:
            return "/book/4.epub"
        }
    }
    
    var query: QueryItems? {
        switch self {
        case .textToSpeechGoogle(_, let apiKey):
            return ["key": apiKey]
        case .downloadTheBook:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .textToSpeechGoogle(let text,_):
            let json: [String: Any] = [
                "input": ["text": text],
                "voice": ["languageCode": "en-US", "name": "en-US-Wavenet-D"],
                "audioConfig": ["audioEncoding": "MP3"]
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            return jsonData
        case .downloadTheBook:
            return nil
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .textToSpeechGoogle:
            return .post
        case .downloadTheBook:
            return .get
        }
    }
    
    var requestEncoding: RequestEncoding? {
        return .json
    }
    
    var authRequired: Bool? {
       return false
    }
    
    var token: String? {
       return nil 
    }
}
