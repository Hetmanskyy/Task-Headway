//
//  BookView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import SwiftUI

struct BookView<Model>: View where Model: BookViewModelInterface {
    @StateObject private var viewModel: Model
    @EnvironmentObject private var router: Router
    
    init(viewModel: Model) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            
            BookImageView(imagePath: viewModel.bookModel?.imageThumb)
            
            BookInfoView(title: viewModel.bookModel?.title ?? "No Title",
                         description: viewModel.bookModel?.description ?? "No Description Available")
            
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                BookControlsView(viewModel: viewModel)
            }
            
            Spacer()
        }
        .padding()
        .multilineTextAlignment(.center)
        .onAppear(perform: fetchBook)
        .onChange(of: viewModel.bookLink) { bookLink in
            if bookLink != nil {
                fetchBook()
            }
        }
        .onChange(of: viewModel.shouldNavigate) { newValue in
            if newValue {
                navigateToContentView()
            }
        }
    }
    
    private func fetchBook() {
        guard let epubURL = Bundle.main.url(forResource: "h-p-lovecraft_at-the-mountains-of-madness", withExtension: "epub") else {
            print("EPUB file not found")
            return
        }
        viewModel.fetchBookWith(url: epubURL)
    }
    
    private func navigateToContentView() {
        router.navigationToContentView(with: viewModel.chaptersModel ?? [])
    }
}
