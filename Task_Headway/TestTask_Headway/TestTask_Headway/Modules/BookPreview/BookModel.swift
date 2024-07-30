//
//  BookModel.swift
//  TestTask_Headway
//
//  Created by user on 27.07.2024.
//

import Foundation

struct BookModel: Codable {
    var title: String
    var description: String
    var imageThumb: String
    var chapters: [ChapterModel]
}

struct ChapterModel: Codable, Identifiable {
    var id: String { number } // Unique identifier for Identifiable conformance
    var title: String
    var number: String
    var content: String
    var imageThumb: String?
    var author: String
    var bookName: String
    var audio: Data
}

struct AudioModel: Codable {
    var audioContent: Data
}
