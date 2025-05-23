//
//  MusicManager.swift
//  Potawatomi tribe game
//
//  Created by Mac on 13.05.2025.
//


import Foundation
import AVFoundation

class MusicManager: ObservableObject {
    static let shared = MusicManager()
    
    @Published var audioPlayerVolume: Float = 0.3
    @Published var paused: Bool = false
    @Published var soundsOn = true
    var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "level-iv-339695 (mp3cut.net)", withExtension: "mp3") else {
            print("Music file not found.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = audioPlayerVolume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing music: \(error.localizedDescription)")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        paused = true
    }
    
    func pauseMusic() {
        audioPlayer?.pause()
        paused = true
    }
    
    func resumeMusic() {
        audioPlayer?.play()
        paused = false
    }
}
