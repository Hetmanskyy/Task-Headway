//
//  BookImageView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import SwiftUI

struct BookImageView: View {
    let imagePath: String?
    
    var body: some View {
        Group {
            if let path = imagePath, let image = loadImage(from: path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipped()
            } else {
                Image("bookCover")
                    .resizable()
                    .scaledToFit()
            }
        }
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
            print("Failed to load image data: \(error.localizedDescription)")
            return nil
        }
    }
}
