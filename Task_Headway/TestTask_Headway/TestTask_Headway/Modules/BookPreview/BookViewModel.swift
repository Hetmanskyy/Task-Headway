//
//  BookViewModel.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import Foundation
import Combine

protocol BookViewModelInterface: ObservableObject {
    var bookModel: BookModel? { get set }
    var chaptersModel: [ChapterModel]? { get set }
    var bookLink: URL? { get set }
    var isLoading: Bool { get set }
    var shouldNavigate: Bool { get set }
    
    init(bookFetcher: BookFetcher)
    
    func fetchBookWith(url: URL)
    func downloadBook(_ url: String)
    func fetchAudioChapters()
}

class BookViewModel: BookViewModelInterface {
    @Published var chaptersModel: [ChapterModel]?
    @Published var isLoading: Bool = false
    @Published var shouldNavigate: Bool = false
    @Published var bookLink: URL? = nil
    @Published var bookModel: BookModel?
    
    private let bookFetcher: BookFetcher
    
    required init(bookFetcher: BookFetcher) {
        self.bookFetcher = bookFetcher
    }
    
    @MainActor
    func fetchBookWith(url: URL) {
        Task {
            do {
                self.isLoading = true
                let bookResponse = try await bookFetcher.loadBook(from: url)
                await MainActor.run {
                    self.bookModel = bookResponse
                    self.isLoading = false
                }
            } catch {
                await MainActor.run{
                    self.bookModel = nil
                    self.isLoading = false
                    print("Failed to fetch book: \(error)")
                }
            }
        }
    }
    
    @MainActor
    func downloadBook(_ url: String) {
        Task {
            do {
                self.isLoading = true
                let bookLink = try await bookFetcher.downloadBook(from: url)
                await MainActor.run {
                    self.bookLink = bookLink
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.bookLink = nil
                    self.isLoading = false
                }
                print("Failed to download book: \(error)")
            }
        }
    }
    
    @MainActor
    func fetchAudioChapters() {
        Task {
            guard let chapters = bookModel?.chapters else { return }
            do {
                self.isLoading = true
                let chaptersResponse = try await bookFetcher.convertTextToSpeech(for: chapters)
               await MainActor.run {
                    self.chaptersModel = chaptersResponse
                    self.isLoading = false
                    self.shouldNavigate = true
                }
            } catch {
                await MainActor.run {
                    self.chaptersModel = nil
                    self.isLoading = false
                    self.shouldNavigate = false
                }
                print("Failed to convert text to speech: \(error)")
            }
        }
    }
}
