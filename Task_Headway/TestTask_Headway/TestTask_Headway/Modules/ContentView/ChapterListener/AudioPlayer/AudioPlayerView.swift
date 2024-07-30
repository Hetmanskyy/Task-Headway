//
//  AudioPlayerViewS.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import SwiftUI

struct AudioPlayerViewS: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(formatTime(viewModel.currentTime))
                    .padding(.leading, 10)
                    .frame(maxWidth: 60, alignment: .leading)
                    .foregroundColor(.gray)
                
                Slider(value: $viewModel.currentTimeSlider, in: 0...viewModel.duration, onEditingChanged: sliderEditingChanged)
                    .accentColor(.blue)
                    .padding(.leading, 5)
                    .padding(.trailing, 5)

                Text(formatTime(viewModel.duration))
                    .padding(.trailing, 10)
                    .frame(maxWidth: 60, alignment: .trailing)
                    .foregroundColor(.gray)
            }
            
            Button(action: viewModel.changePlaybackRate) {
                Text("Speed x\(viewModel.playbackRate, specifier: "%.1f")")
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
            HStack(spacing: 30) {
                Button(action: viewModel.previousChapter) {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                }
                
                Button(action: viewModel.skipBackward) {
                    Image(systemName: "gobackward.10")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                }
                
                Button(action: viewModel.playPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                }
                
                Button(action: viewModel.skipForward) {
                    Image(systemName: "goforward.10")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                }
                
                Button(action: viewModel.nextChapter) {
                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 50)
        }
        .padding()
    }

    private func sliderEditingChanged(editingStarted: Bool) {
        viewModel.isSeeking = editingStarted
        if !editingStarted {
            viewModel.seek(to: viewModel.currentTimeSlider)
        }
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
