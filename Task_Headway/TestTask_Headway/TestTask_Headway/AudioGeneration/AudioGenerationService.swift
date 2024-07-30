//
//  AudioGenerationService.swift
//  TestTask_Headway
//
//  Created by user on 27.07.2024.
//

import Foundation

protocol AudioGenerationService {
    func textToSpeechGoogle(text: String, apiKey: String) async throws -> Data
    func downloadTheBook(url: String) async throws -> Data
}
