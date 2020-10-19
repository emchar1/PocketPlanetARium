//
//  AudioManager.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/18/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import Foundation
import AVFoundation


// MARK: - Audio Enums

enum AudioType: String {
    case mp3 = "mp3", wav, m4a
}

enum AudioCategory {
    case music, soundFX
}

enum AudioTheme: String {
    case main = "main", starWars, superMario
}


// MARK: - AudioItem

struct AudioItem {
    let fileName: String
    let fileType: AudioType
    let category: AudioCategory
    let maxVolume: Float
    var player = AVAudioPlayer()
    
    init(fileName: String, fileType: AudioType = .mp3, category: AudioCategory, maxVolume: Float = 1.0) {
        self.fileName = fileName
        self.fileType = fileType
        self.category = category
        self.maxVolume = maxVolume
    }
}


// MARK: - AudioManager

struct AudioManager {
    var theme: AudioTheme
    var audioItems: [String : AudioItem]
    
    
    init(with theme: AudioTheme = .main) {
        self.theme = theme

        audioItems = [:]
        audioItems["MenuScreen"] = AudioItem(fileName: theme.rawValue + "_MenuScreen", category: .music)
        audioItems["MenuButtonPress"] = AudioItem(fileName: "17464625_button-tap_by_3dhome_preview", category: .soundFX)
        audioItems["GoButton"] = AudioItem(fileName: theme.rawValue + "_GoButton", category: .soundFX)
        audioItems["PlanetARiumOpen"] = AudioItem(fileName: theme.rawValue + "_PlanetARiumOpen", category: .soundFX, maxVolume: 0.5)
        audioItems["PlanetARiumMusic"] = AudioItem(fileName: theme.rawValue + "_PlanetARiumMusic", category: .music)
        audioItems["ButtonPress"] = AudioItem(fileName: theme.rawValue + "_ButtonPress", category: .soundFX, maxVolume: 0.5)
        audioItems["SettingsExpand"] = AudioItem(fileName: theme.rawValue + "_SettingsExpand", category: .soundFX)
        audioItems["SettingsCollapse"] = AudioItem(fileName: theme.rawValue + "_SettingsCollapse", category: .soundFX, maxVolume: 0.5)
        audioItems["PinchShrink"] = AudioItem(fileName: theme.rawValue + "_Pinch", category: .soundFX)
        audioItems["PinchGrow"] = AudioItem(fileName: theme.rawValue + "_Pinch", category: .soundFX)
        audioItems["DetailsOpen"] = AudioItem(fileName: theme.rawValue + "_DetailsOpen", category: .soundFX)
        audioItems["VenusSurface"] = AudioItem(fileName: theme.rawValue + "_VenusSurface", category: .soundFX)
    }

    /**
     Sets up the individual audio players for the various sounds.
     */
    mutating func setupSounds() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print(error)
        }
        
        for (key, item) in audioItems {
            if let player = configureAudioPlayer(for: item) {
                audioItems[key]?.player = player
            }
        }
    }
    
    /**
     Helper method for setupSounds(). Takes in an AudioItem, sets up and returns the new player.
     - parameter audioItem: AudioItem to configure the player
     */
    private func configureAudioPlayer(for audioItem: AudioItem) -> AVAudioPlayer? {
        guard let audioURL = Bundle.main.path(forResource: audioItem.fileName, ofType: audioItem.fileType.rawValue) else {
            print("Unable to find sound file: \(audioItem.fileName).\(audioItem.fileType.rawValue)")
            return nil
        }
        
        do {
            var audioPlayer = audioItem.player
            
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioURL))
            audioPlayer.volume = UserDefaults.standard.bool(forKey: K.userDefaultsKey_SoundIsMuted) ? 0.0 : audioItem.maxVolume
            audioPlayer.numberOfLoops = audioItem.category == .music ? -1 : 0
            
            return audioPlayer
        }
        catch {
            print(error)
        }
        
        return nil
    }
    
    /**
     Plays a sound for a given key that exists in the audioItems dictionary.
     - parameters:
        - audioKey: the key for the audio item to play
        - currentTime: currentTime to start the playback at; if nil, don't set
        - pan: pan value to initialize, defaults to center of player
     */
    func playSound(for audioKey: String, currentTime: TimeInterval? = nil, pan: Float = 0) {
        guard let item = audioItems[audioKey] else {
            print("Unable to find \(audioKey) in AudioManager.audioItems[]")
            return
        }
        
        if currentTime != nil {
            item.player.currentTime = currentTime!
        }

        item.player.pan = pan
        item.player.play()
    }
    
    /**
     Stops playing a specified audio item, with decrescendo if needed.
     - parameters:
        - audioKey: the key for the audio item to stop
        - fadeDuration: length of time in seconds for music to fade before stopping.
     */
    func stopSound(for audioKey: String, fadeDuration: TimeInterval = 0.0) {
        guard let item = audioItems[audioKey] else {
            print("Unable to find \(audioKey) in AudioManager.audioItems[]")
            return
        }
        
        item.player.setVolume(0.0, fadeDuration: fadeDuration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) {
            item.player.stop()
        }
    }
    
    /**
     Sets the pan of the audioItem.
     - parameters:
        - audioKey: the key for the audio item to set the pan for
        - pan: pan value to set to
     */
    func setPan(for audioKey: String, to pan: Float) {
        guard let item = audioItems[audioKey] else {
            print("Unable to find \(audioKey) in AudioManager.audioItems[]")
            return
        }
        
        let panAdusted = pan.clamp(min: -1.0, max: 1.0)
        
        item.player.pan = panAdusted
    }
    
    /**
     Updates the volume across all audio players. Sets it to 0 (off) or 1 (on) based on if the app is muted or not.
     */
    func updateVolumes() {
        for (_, item) in audioItems {
            let volumeToSet: Float = UserDefaults.standard.bool(forKey: K.userDefaultsKey_SoundIsMuted) ? 0.0 : item.maxVolume
            
            if item.category == .music {
                item.player.setVolume(volumeToSet, fadeDuration: 0.25)
            }
            else {
                item.player.volume = volumeToSet
            }
        }
    }
    
    
}
