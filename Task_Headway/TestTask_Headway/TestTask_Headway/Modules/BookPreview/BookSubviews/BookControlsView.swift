//
//  BookControlsView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import SwiftUI

struct BookControlsView<Model>: View where Model: BookViewModelInterface {
    @ObservedObject var viewModel: Model
    
    var body: some View {
        Button(action: {
            viewModel.fetchAudioChapters()
        }) {
            Text("Listen book")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
