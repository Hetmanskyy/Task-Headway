//
//  Router.swift
//  TestTask_Headway
//
//  Created by user on 27.07.2024.
//

import Combine
import SwiftUI

class Router: ObservableObject {
    @Published var currentScreen: SceenRotation = .book
    
    enum SceenRotation {
        case book
        case contentView(ContentViewModel)
    }
    
    func navigationToContentView(with chapters: [ChapterModel]) {
        let viewModel = ContentViewModel(chapters: chapters, currentChapterIndex: 0)
        currentScreen = .contentView(viewModel)
    }
    
    func navigationBackToBook() {
        currentScreen = .book
    }
}
