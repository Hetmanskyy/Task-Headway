//
//  TestTask_HeadwayApp.swift
//  TestTask_Headway
//
//  Created by user on 27.07.2024.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

@main
struct TestTask_HeadwayApp: App {
    @StateObject private var router = Router()
    
    var body: some Scene {
        let apiURL = URL(string: Constants.googleTTS)!
        let keyProvider = Provider<AudioGenerationAPIBuilder, ErrorHandlerImpl>(baseURL: apiURL, requestBuilder: AudioGenerationAPIBuilder.self)
        let viewModel = BookViewModel(bookFetcher: BookFetcher(audioGenerationService: AudioGenerationServiceImp(keyProvider)))
        
        WindowGroup {
            Group {
                switch router.currentScreen {
                case .book:
                    BookView(viewModel: viewModel).environmentObject(router)
                case .contentView(let contentViewModel):
                    ContentView(viewModel: contentViewModel).environmentObject(router)
                }
            }
            .environmentObject(router)
        }
    }
}
