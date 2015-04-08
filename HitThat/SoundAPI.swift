//
//  SoundAPI.swift
//  HitThat
//
//  Created by Jake Seaton on 4/7/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

struct SoundAPI {
    static let allFightSounds:[String:String] = ["meatSlap":"aif", "Slap":"mp3", "slapFight": "wav", "punch":"wav"]
    func getArrayOfSoundsPlayers() -> [AVAudioPlayer]{
        var result:[AVAudioPlayer] = []
        for (name, type) in SoundAPI.allFightSounds{
            let soundPath = NSBundle.mainBundle().pathForResource(name, ofType: type)
            let soundURL:NSURL = NSURL(fileURLWithPath: soundPath!)!
            let player = AVAudioPlayer(contentsOfURL: soundURL, error: nil)
            player.prepareToPlay()
            result.append(player)
        }
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil)
        return result
        
    }
}
