//
//  AudioPlayerUtility.swift
//  FinalApplication
//
//  Created by Admin on 18.01.24.
//

import AVFoundation

class AudioPlayerUtility {
    static var player: AVAudioPlayer?
    
    static func playAudio(forResource resource: String, withExtension ext: String) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
            print("Audio file not found")
            return
        }
        
        do {
            
            if let existingPlayer = player, existingPlayer.isPlaying {
                existingPlayer.stop()
            }
            
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            self.player = newPlayer
            newPlayer.play()
        } catch let error {
            print("Error in playing audio: \(error)")
        }
    }
}

