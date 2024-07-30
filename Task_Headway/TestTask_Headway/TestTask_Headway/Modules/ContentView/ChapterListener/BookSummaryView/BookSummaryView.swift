//
//  BookSummaryView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//


import SwiftUI

struct BookSummaryView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    // Initialize with a view model
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if let currentChapter = viewModel.currentChapter {
                if let imagePath = currentChapter.imageThumb, let image = viewModel.loadImage(from: imagePath) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    placeholderImage
                }
                
                Text("KEY POINT \(viewModel.currentChapterIndex + 1) OF \(viewModel.chapters.count)")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text("Chapter: \(currentChapter.title)")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                Text("No Chapter Selected")
                    .font(.headline)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private var placeholderImage: some View {
        Image("bookCover")
            .resizable()
            .scaledToFit()
            .padding()
    }
}
