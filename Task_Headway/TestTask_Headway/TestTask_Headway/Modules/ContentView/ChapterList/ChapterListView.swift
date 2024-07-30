//
//  ChapterListView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import SwiftUI

struct ChapterListView: View {
    @StateObject var viewModel: ContentViewModel
    @Binding var selectedSegment: Int
    
    let height: CGFloat = 150
    var body : some View{
        
        List(viewModel.chapters.indices, id: \.self) { index in
            
            HStack{
                
                if let imagePath = viewModel.chapters[index].imageThumb, let  image = loadImage(from: imagePath) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 120, height: 170)
                        .cornerRadius(10)
                } else {
                    placeholderImage
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Chapter: \(viewModel.chapters[index].title)")
                        .fontWeight(.bold)
                    
                    Text(viewModel.chapters[index].bookName)
                    
                    Text(viewModel.chapters[index].author)
                        .font(.caption)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
            }
            .onTapGesture {
                viewModel.currentChapterIndex = index
                selectedSegment = 0
            }
            
        }
        .listStyle(.plain)
    }
    
    private var placeholderImage: some View {
        Image("bookCover")
            .resizable()
            .frame(width: 120, height: 170)
            .cornerRadius(10)
    }

    
    private func loadImage(from path: String) -> UIImage? {
        guard let url = URL(string: path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                print("Image successfully loaded")
                return image
            } else {
                print("Failed to create image from data")
                return nil
            }
        } catch {
            print("Failed to load image data: (error.localizedDescription)")
            return nil
        }
    }

}
