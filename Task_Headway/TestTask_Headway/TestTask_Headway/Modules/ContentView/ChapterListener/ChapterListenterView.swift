//
//  ChapterListenterView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import SwiftUI

struct ChapterListenterView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            BookSummaryView(viewModel: viewModel)
            AudioPlayerViewS(viewModel: viewModel)
        }
        .padding()
    }
}
