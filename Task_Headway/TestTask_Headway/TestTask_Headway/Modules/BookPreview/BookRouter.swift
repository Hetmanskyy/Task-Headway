//
//  BookRouter.swift
//  TestTask_Headway
//
//  Created by user on 27.07.2024.
//

import Combine
import SwiftUI

enum BookRouter {
    static func makeContentView(with chapters: [ChapterModel], router: Router) {
        router.navigationToContentView(with: chapters)
    }
}
