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
    case main = "main", mario, starWars
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

class AudioManager {
    static let shared: AudioManager = {
        let instance = AudioManager()
        //additional setup, if needed
        return instance
    }()
    
    var theme: AudioTheme = .main
    var audioItems: [String : AudioItem] = [:]
    var launchMessage: String {
        let noCameraAccessString = "Camera access is denied.\nPlanetARium may act unpredictably."
        var successString: String
        
        switch theme {
        case .main:
            successString = "Remember to always be aware\nof your surroundings."
        case .mario:
            successString = "Happy Mar10 Day!"
        case .starWars:
            successString =  "May the Force be with you."
        }
        
        return AudioManager.shared.checkForCamera() == .authorized ? successString : noCameraAccessString
    }
    

    // MARK: - Setup
    
    init(with theme: AudioTheme = .main) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print(error)
        }
        
        audioItems["MenuScreen"] = AudioItem(fileName: "main_MenuScreen", category: .music)
        
        if let item = audioItems["MenuScreen"], let player = configureAudioPlayer(for: item) {
            audioItems["MenuScreen"]?.player = player
        }
        
        setTheme(theme)
    }

    /**
     Sets up the individual audio players for the various sounds. It won't setup MenuScreen sound because that's set up in initialization.
     */
    private func setupSounds() {
        for (key, item) in audioItems {
            if let player = configureAudioPlayer(for: item), key != "MenuScreen" {
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
    
    
    // MARK: - Playback
    
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
        item.player.prepareToPlay()
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
    
    
    // MARK: - Set Sound Themes
    
    func setTheme(_ theme: AudioTheme) {
        self.theme = theme

        switch theme {
        case .main:
            setThemeMain()
        case .mario:
            setThemeMario()
        case .starWars:
            setThemeStarWars()
        }
        
        setupSounds()
    }

    private func setThemeMain() {
        audioItems["MenuTitle"] = AudioItem(fileName: "main_MenuTitle", category: .soundFX)
        audioItems["MenuButton"] = AudioItem(fileName: "main_MenuButton", category: .soundFX, maxVolume: 0.5)
        audioItems["LaunchButton"] = AudioItem(fileName: "main_LaunchButton", category: .soundFX)
        audioItems["PlanetARiumOpen"] = AudioItem(fileName: "main_PlanetARiumOpen", category: .soundFX, maxVolume: 0.5)
        audioItems["PlanetARiumMusic"] = AudioItem(fileName: "main_PlanetARiumMusic0", category: .music)
        audioItems["ButtonPress"] = AudioItem(fileName: "main_ButtonPress", category: .soundFX, maxVolume: 0.5)
        audioItems["ButtonPressInfo"] = AudioItem(fileName: "main_ButtonPress", category: .soundFX, maxVolume: 0.5)
        audioItems["ButtonPressPause"] = AudioItem(fileName: "main_ButtonPress", category: .soundFX, maxVolume: 0.5)
        audioItems["ButtonPressReset"] = AudioItem(fileName: "main_ButtonPress", category: .soundFX, maxVolume: 0.5)
        audioItems["SettingsExpand"] = AudioItem(fileName: "main_SettingsExpand", category: .soundFX)
        audioItems["SettingsCollapse"] = AudioItem(fileName: "main_SettingsCollapse", category: .soundFX, maxVolume: 0.5)
        audioItems["PinchShrink"] = AudioItem(fileName: "main_MenuTitle", category: .soundFX)
        audioItems["PinchGrow"] = AudioItem(fileName: "main_Pinch", category: .soundFX)
        audioItems["DetailsOpen"] = AudioItem(fileName: "main_DetailsOpen", category: .soundFX)
        audioItems["VenusSurface"] = AudioItem(fileName: "main_VenusSurface", category: .soundFX)
    }
        
    
    
    
    
    
    //EXPERIMENTAL SOUNDS
    private func setThemeMario() {
        audioItems["MenuTitle"] = AudioItem(fileName: "main_MenuTitle", category: .soundFX)
        audioItems["MenuButton"] = AudioItem(fileName: "main_MenuButton", category: .soundFX, maxVolume: 0.5)
        audioItems["LaunchButton"] = AudioItem(fileName: "mario_LaunchButton", fileType: .wav, category: .soundFX)
        audioItems["PlanetARiumOpen"] = AudioItem(fileName: "main_PlanetARiumOpen", category: .soundFX, maxVolume: 0.5)
        audioItems["PlanetARiumMusic"] = AudioItem(fileName: "mario_PlanetARiumMusic\(Int.random(in: 0...1))", category: .music)
        audioItems["ButtonPress"] = AudioItem(fileName: "mario_ButtonPress", fileType: .wav, category: .soundFX)
        audioItems["ButtonPressInfo"] = AudioItem(fileName: "mario_ButtonPress", fileType: .wav, category: .soundFX)
        audioItems["ButtonPressPause"] = AudioItem(fileName: "mario_ButtonPressPause", fileType: .wav, category: .soundFX)
        audioItems["ButtonPressReset"] = AudioItem(fileName: "mario_ButtonPress", fileType: .wav, category: .soundFX)
        audioItems["SettingsExpand"] = AudioItem(fileName: "mario_SettingsExpand", fileType: .wav, category: .soundFX)
        audioItems["SettingsCollapse"] = AudioItem(fileName: "mario_SettingsCollapse", fileType: .wav, category: .soundFX)
        audioItems["PinchShrink"] = AudioItem(fileName: "mario_PinchShrink", fileType: .wav, category: .soundFX)
        audioItems["PinchGrow"] = AudioItem(fileName: "mario_PinchGrow", fileType: .wav, category: .soundFX)
        audioItems["DetailsOpen"] = AudioItem(fileName: "mario_DetailsOpen", fileType: .wav, category: .soundFX)
        audioItems["VenusSurface"] = AudioItem(fileName: "mario_VenusSurface", fileType: .wav, category: .soundFX)
    }
    
    private func setThemeStarWars() {
        audioItems["MenuTitle"] = AudioItem(fileName: "main_MenuTitle", category: .soundFX)
        audioItems["MenuButton"] = AudioItem(fileName: "main_MenuButton", category: .soundFX, maxVolume: 0.5)
        audioItems["LaunchButton"] = AudioItem(fileName: "starWars_LaunchButton", category: .soundFX)
        audioItems["PlanetARiumOpen"] = AudioItem(fileName: "main_PlanetARiumOpen", category: .soundFX, maxVolume: 0.5)
        audioItems["PlanetARiumMusic"] = AudioItem(fileName: "starWars_PlanetARiumMusic0", category: .music)
        audioItems["ButtonPress"] = AudioItem(fileName: "main_ButtonPress", category: .soundFX)
        audioItems["ButtonPressInfo"] = AudioItem(fileName: "main_ButtonPress", category: .soundFX, maxVolume: 0.5)
        audioItems["ButtonPressPause"] = AudioItem(fileName: "main_ButtonPress", category: .soundFX, maxVolume: 0.5)
        audioItems["ButtonPressReset"] = AudioItem(fileName: "main_ButtonPress", category: .soundFX, maxVolume: 0.5)
        audioItems["SettingsExpand"] = AudioItem(fileName: "starWars_SettingsExpand", category: .soundFX)
        audioItems["SettingsCollapse"] = AudioItem(fileName: "starWars_SettingsCollapse", category: .soundFX)
        audioItems["PinchShrink"] = AudioItem(fileName: "starWars_pinchShrink", category: .soundFX)
        audioItems["PinchGrow"] = AudioItem(fileName: "starWars_pinchGrow", category: .soundFX)
        audioItems["DetailsOpen"] = AudioItem(fileName: "starWars_DetailsOpen", category: .soundFX)
        audioItems["VenusSurface"] = AudioItem(fileName: "starWars_VenusSurface", category: .soundFX)
    }
    
    
    // MARK: - Other Functions
    
    func requestCamera() {
        guard checkForCamera() == .notDetermined else { return print("   AudioManager.requestCamera() status: !(.notDetermined), exiting...") }
        
        AVCaptureDevice.requestAccess(for: .video) { _ in
            print("   AudioManager.requestCamera() status: .notDetermined, requesting access...")
        }
    }
    
    @discardableResult func checkForCamera() -> AVAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:       //User previously granted access to camera
            print("AudioManager.checkForCamera() status: .authorized")
        case .notDetermined:    //User hasn't been asked for camera access
            print("AudioManager.checkForCamera() status: .notDetermined")
        case .denied:           //User previously denied access
            print("AudioManager.checkForCamera() status: .denied")
        case .restricted:       //User unable to grant access due to restrictions
            print("AudioManager.checkForCamera() status: .restricted")
        @unknown default:       //Handle any future cases not listed
            print("AudioManager.checkForCamera() status: @unknown")
        }
        
        return status
    }
}
