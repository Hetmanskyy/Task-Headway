//
//  AudioGenerationServiceImp.swift
//  TestTask_Headway
//
//  Created by user on 27.07.2024.
//

import Foundation

class AudioGenerationServiceImp {
    private let  provider: Provider<AudioGenerationAPIBuilder, ErrorHandlerImpl>
    
    init(_ provider: Provider<AudioGenerationAPIBuilder, ErrorHandlerImpl>) {
        self.provider = provider
    }
}

extension AudioGenerationServiceImp: AudioGenerationService {
    func downloadTheBook(url: String) async throws -> Data {
        try await provider.generalPerform(builder: .downloadTheBook(url: url))
    }
    
    func textToSpeechGoogle(text: String, apiKey: String) async throws -> Data {
        try await provider.generalPerform(builder: .textToSpeechGoogle(text: text, apiKey: apiKey))
    }
}
