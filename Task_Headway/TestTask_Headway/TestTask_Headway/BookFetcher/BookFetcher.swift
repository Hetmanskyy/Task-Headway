//
//  BookFetcher.swift
//  TestTask_Headway
//
//  Created by user on 27.07.2024.
//

import Foundation
import EPUBKit
import SwiftSoup

protocol BookFetchable {
    func downloadBook(from url: String) async throws -> URL
    func loadBook(from epubURL: URL) async throws -> BookModel
    func convertTextToSpeech(for chapters: [ChapterModel]) async throws -> [ChapterModel]
}

class BookFetcher: BookFetchable {
    private var book: BookModel?
    private var bookDocument: EPUBDocument?
    private let downloadDirectory: URL
    private let apiURL = URL(string: Constants.googleTTS)
    private let apiKey = Constants.apiKey
    private var audioGenerationService: AudioGenerationService?

    init(audioGenerationService: AudioGenerationService) {
        self.downloadDirectory = FileManager.default.temporaryDirectory
        self.audioGenerationService = audioGenerationService
    }

    func downloadBook(from url: String) async throws -> URL {
        let data = try await self.audioGenerationService?.downloadTheBook(url: url)
        guard let epubData = data else {
            throw URLError(.badServerResponse)
        }
        
        let epubURL = self.downloadDirectory.appendingPathComponent(Constants.pathComponent)
        try epubData.write(to: epubURL)
        
        return epubURL
    }

    func loadBook(from epubURL: URL) async throws -> BookModel {
        let bookDocument = EPUBDocument(url: epubURL)
        self.bookDocument = bookDocument

        let bookTitle = bookDocument?.metadata.title ?? "Unknown Title"
        let bookDescription = bookDocument?.metadata.description ?? ""
        var coverImageURLString: String = ""
        
        if let coverURL = bookDocument?.cover {
            coverImageURLString = coverURL.absoluteString
        }

        let chapters = (bookDocument?.tableOfContents.subTable ?? []).enumerated().compactMap { index, chapter -> ChapterModel? in
            guard let href = chapter.item, let contentDirectory = bookDocument?.contentDirectory else { return nil }
            let chapterURL = contentDirectory.appendingPathComponent(href)
            guard let contentData = try? Data(contentsOf: chapterURL),
                  let contentString = String(data: contentData, encoding: .utf8) else {
                return nil
            }

            let text = self.extractTextFromHTML(htmlString: contentString)
            guard text.count > Constants.prefixLimit - 1 else { return nil }

            let author = bookDocument?.author
            let bookName = bookTitle
            return ChapterModel(title: chapter.label,
                                number: "\(index + 1)",
                                content: text,
                                imageThumb: coverImageURLString, author: author ?? "",
                                bookName: bookName,
                                audio: Data())
        }.prefix(10)

        let chaptersArray = Array(chapters)

        let bookModel = BookModel(title: bookTitle,
                                  description: bookDescription,
                                  imageThumb: coverImageURLString,
                                  chapters: chaptersArray)

        self.book = bookModel
        return bookModel
    }

    private func extractTextFromHTML(htmlString: String) -> String {
        do {
            let document = try SwiftSoup.parse(htmlString)
            let text = try document.text()
            return String(text.prefix(Constants.prefixLimit))
        } catch {
            print("Failed to parse HTML: \(error.localizedDescription)")
            return ""
        }
    }

    func convertTextToSpeech(for chapters: [ChapterModel]) async throws -> [ChapterModel] {
        let results = try await withThrowingTaskGroup(of: (String, Data).self) { group -> [(String, Data)] in
            for chapter in chapters {
                group.addTask {
                    do {
                        guard let data = try await self.audioGenerationService?.textToSpeechGoogle(text: chapter.content, apiKey: self.apiKey) else {
                            throw URLError(.badServerResponse)
                        }
                        if try JSONSerialization.jsonObject(with: data, options: []) is [String: Any] {
                            let decoder = JSONDecoder()
                            if let audioModel = try? decoder.decode(AudioModel.self, from: data) {
                                return (chapter.number, audioModel.audioContent)
                            } else {
                                throw URLError(.badServerResponse)
                            }
                        } else {
                            throw URLError(.badServerResponse)
                        }
                    } catch {
                        throw error
                    }
                }
            }
            
            var results: [(String, Data)] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
        
        var updatedChapters = chapters
        for (chapterNumber, audioData) in results {
            if let index = updatedChapters.firstIndex(where: { $0.number == chapterNumber }) {
                updatedChapters[index].audio = audioData
            }
        }
        
        return updatedChapters
    }
}
