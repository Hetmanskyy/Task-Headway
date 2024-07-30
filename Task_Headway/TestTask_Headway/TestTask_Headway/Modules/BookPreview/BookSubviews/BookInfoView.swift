//
//  BookInfoView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import SwiftUI

struct BookInfoView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.body)
                .padding(.top, 5)
                .multilineTextAlignment(.center)
        }
    }
}
