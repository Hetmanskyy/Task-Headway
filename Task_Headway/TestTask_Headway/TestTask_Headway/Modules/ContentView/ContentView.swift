//
//  ContentView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var selectedSegment = 0
    private let segments = ["headphones", "list.dash"]

    var body: some View {
        VStack {
            // Switch views based on selected segment index
            switch selectedSegment {
            case 0:
                ChapterListenterView(viewModel: viewModel)
            case 1:
                ChapterListView(viewModel: viewModel, selectedSegment: $selectedSegment)
            default:
                EmptyView()
            }
            
            CustomSegmentControlView(selectedSegment: $selectedSegment, segments: segments)
            .padding()

        }
    }
}
