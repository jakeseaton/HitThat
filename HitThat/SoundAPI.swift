//
//  SoundAPI.swift
//  HitThat
//
//  Created by Jake Seaton on 4/7/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

struct SoundAPI {
    static let notificationSound = "punch.wav"
    static let victorySound = "punch"
    static let lossSound = "meatSlap"
    static let allFightSounds:[String:String] = ["meatSlap":"aif", "Slap":"mp3", "slapFight": "wav", "punch":"wav"]
    func soundNameToAudioPlayer(soundName:String) -> AVAudioPlayer {
        let soundPath = NSBundle.mainBundle().pathForResource(soundName, ofType: SoundAPI.allFightSounds[soundName])
        let soundURL = NSURL(fileURLWithPath: soundPath!)!
        let player = AVAudioPlayer(contentsOfURL: soundURL, error: nil)
        player.prepareToPlay()
        config()
        return player
    }
    func getArrayOfSoundsPlayers() -> [AVAudioPlayer]{
        var result:[AVAudioPlayer] = []
        for (name, type) in SoundAPI.allFightSounds{
            result.append(soundNameToAudioPlayer(name))
        }
        config()
        return result
    }
    func playVictorySound(){
        config()
        SoundAPI().soundNameToAudioPlayer(SoundAPI.victorySound).play()
    }
    func config(){
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil)
    }
    func getVictorySound() -> AVAudioPlayer{
        return soundNameToAudioPlayer(SoundAPI.victorySound)
    }
    func getLossSound()-> AVAudioPlayer{
        return soundNameToAudioPlayer(SoundAPI.lossSound)        
    }
}
