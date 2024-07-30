//
//  ContentViewModel.swift
//  TestTask_Headway
//
//  Created by user on 28.07.2024.
//

import Foundation
import Combine
import SwiftUI
import AVFoundation

class ContentViewModel: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    @Published var isSeeking: Bool = false
    @Published var chapters: [ChapterModel] = []
    @Published var currentChapterIndex: Int
    @Published var currentTime: Double = 0.0
    @Published var currentTimeSlider: Double = 0.0 // Separate for slider interaction
    @Published var duration: Double = 0.0
    @Published var isPlaying: Bool = false
    @Published var playbackRate: Float = 1.0
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    init(chapters: [ChapterModel], currentChapterIndex: Int) {
        self.chapters = chapters
        self.currentChapterIndex = currentChapterIndex
        loadAudioData(for: currentChapterIndex)
        setupTimer()
        updateTimer()
        observeCurrentChapterIndex()
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateCurrentTime()
        }
    }

    private func updateCurrentTime() {
        guard let player = audioPlayer else { return }
        if isPlaying && !isSeeking {
            currentTime = player.currentTime
            currentTimeSlider = player.currentTime
        }
        duration = player.duration
    }
    
    private func observeCurrentChapterIndex() {
        $currentChapterIndex
            .sink { [weak self] index in
                self?.loadAudioData(for: index)
                self?.updateTimer()
                self?.playPause()
            }
            .store(in: &cancellables)
    }
    
    private func updateTimer() {
        guard let player = audioPlayer else { return }
        currentTime = player.currentTime
        duration = player.duration
        currentTimeSlider = 0.0
    }

    func playPause() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }

    func skipForward() {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime + 10.0
        player.currentTime = min(newTime, player.duration) // Ensure time does not exceed duration
    }

    func skipBackward() {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime - 10.0
        player.currentTime = max(newTime, 0) // Ensure time does not go below 0
    }

    func changePlaybackRate() {
        switch playbackRate {
        case 1.0:
            playbackRate = 1.5
        case 1.5:
            playbackRate = 2.0
        case 2.0:
            playbackRate = 0.5
        case 0.5:
            playbackRate = 1.0
        default:
            playbackRate = 1.0
        }

        audioPlayer?.rate = playbackRate
    }

    func seek(to time: Double) {
        audioPlayer?.currentTime = time
        currentTime = time
        currentTimeSlider = time
    }

    func loadAudioData(for chapterIndex: Int) {
        guard chapterIndex >= 0, chapterIndex < chapters.count else { return }
        let chapter = chapters[chapterIndex]
        let audioData = chapter.audio

        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.enableRate = true // Enable playback rate adjustment
            audioPlayer?.prepareToPlay()
            audioPlayer?.rate = playbackRate
            audioPlayer?.currentTime = 0
            
        } catch {
            print("Failed to initialize audio player: \(error.localizedDescription)")
        }
    }

    func nextChapter() {
        guard currentChapterIndex + 1 < chapters.count else { return }
        currentChapterIndex += 1
    }

    func previousChapter() {
        guard currentChapterIndex - 1 >= 0 else { return }
        currentChapterIndex -= 1
    }

    var currentChapter: ChapterModel? {
        guard currentChapterIndex >= 0, currentChapterIndex < chapters.count else {
            return nil
        }
        return chapters[currentChapterIndex]
    }
    
    func loadImage(from path: String) -> UIImage? {
         guard let fileURL = URL(string: path) else {
             return nil
         }
         
         if let image = UIImage(contentsOfFile: fileURL.path) {
             return image
         } else {
             return nil
         }
     }
}
