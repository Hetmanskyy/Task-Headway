//
//  ChapterCard.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import Foundation
import SwiftUI

struct ChapterCard: View {
    var chapter: ChapterModel
    
    var body: some View {
        VStack() {
            Spacer()
            if let imagePath = chapter.imageThumb, let  image = loadImage(from: imagePath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholderImage
            }
            Text("Chapter: \(chapter.title)")
                .padding(8.0)
                .font(.bold(.custom("Helvetica", size: 11.0))())
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
        }
    }
    
    private var placeholderImage: some View {
        Image("bookCover")
            .resizable()
            .scaledToFit()
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
