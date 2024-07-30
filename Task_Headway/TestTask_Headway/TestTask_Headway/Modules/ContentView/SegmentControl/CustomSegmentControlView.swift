//
//  CustomSegmentControlView.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import Foundation
import SwiftUI

struct CustomSegmentControlView: View {
    @Binding var selectedSegment: Int
    let segments: [String]
    
    var body: some View {
        HStack {
            ForEach(0..<segments.count, id: \.self) { index in
                Button(action: {
                    withAnimation {
                        selectedSegment = index
                    }
                }) {
                    Image(systemName: segments[index])
                        .fontWeight(.medium)
                        .padding()
                        .foregroundColor(selectedSegment == index ? .white : .black)
                        .background(selectedSegment == index ? Color.blue : Color.clear)
                        .cornerRadius(25)
                }
                .frame(maxWidth: 50)
            }
        }
        .padding(4)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(25)
    }
}
