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
    var audioItems: [String : AudioItem] = [
        "StarWars" : AudioItem(fileName: "starwarstheme", category: .music),
        "OuterSpace" : AudioItem(fileName: "25032559_space-travel_by_phillipmariani_preview", category: .music),
        "GoButton" : AudioItem(fileName: "9121155_tick_by_royaltyfreesounds_preview", category: .soundFX),
        "PlanetARiumOpen" : AudioItem(fileName: "22999267_spaceship-door-open_by_happymusichappysounds_preview", category: .soundFX),
        "ButtonPress" : AudioItem(fileName: "19191098_industrial-switch-4_by_stormwaveaudio_preview", category: .soundFX, maxVolume: 0.5),
        "SettingsExpand" : AudioItem(fileName: "24718337_zoom_by_volkovsound_preview", category: .soundFX),
        "SettingsCollapse" : AudioItem(fileName: "25445208_soft-drink-can-open_by_audiopros_preview", category: .soundFX),
        "PinchShrink" : AudioItem(fileName: "8108259_zoom-in_by_stockwaves_preview", category: .soundFX),
        "PinchGrow" : AudioItem(fileName: "8108259_zoom-in_by_stockwaves_preview", category: .soundFX),
        "DetailsOpen" : AudioItem(fileName: "19220675_blip_by_3dhome_preview", category: .soundFX),
        "Venus Surface" : AudioItem(fileName: "26554041_notification-blip-5_by_biggest_preview", category: .soundFX)
    ]

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
