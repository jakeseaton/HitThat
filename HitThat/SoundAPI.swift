//
//  SoundAPI.swift
//  HitThat
//
//  Created by Jake Seaton on 4/7/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

struct SoundAPI {

    static let allSounds = [
        "meatSlap":"aif",
        "Slap":"mp3",
        "slapFight": "wav",
        "punch":"wav",
        "dunDunDun1":"wav",
        "dunDunDun2":"wav",
        "Explosion": "wav",
        "drumroll":"aif",
        "grunt1":"wav",
        "grunt2":"wav",
        "grunt3":"wav",
        "femaleGrunt1":"wav",
        "femaleGrunt2":"wav",
        "applause":"wav",
        "ThreePunch":"wav",
        "targetLocked":"wav",
        "shout1":"wav"
    ]

    static let jabSound = "punch"
    static let kickSound = "grunt1"
    static let blockSound = "Slap"
    static let upperCutSound = "meatSlap"

    static let notificationSound = "punch"
    static let dieSound = "shout1"
    static let startFightSound = "ThreePunch"
    static let victorySound = "applause"
    static let lossSound = "ThreePunch"
    static let targetLockedSound = "targetLocked"
    static let allFightSounds:[String] = ["meatSlap", "Slap", "slapFight", "punch"]
    static let allMatchSounds:[String] = ["dunDunDun1", "dunDunDun2", "Explosion", "drumroll"]
    static let femaleGruntSounds:[String] = ["femaleGrunt1","femaleGrunt2"]
    static let maleGruntSounds:[String] = ["grunt1", "grunt2", "grunt3"]
    //static let blockSounds:[String:String] = []
    
    func soundNameToAudioPlayer(soundName:String) -> AVAudioPlayer {
        let soundPath = NSBundle.mainBundle().pathForResource(soundName, ofType: SoundAPI.allSounds[soundName])
        let soundURL = NSURL(fileURLWithPath: soundPath!)!
        let player = AVAudioPlayer(contentsOfURL: soundURL, error: nil)
        player.prepareToPlay()
        config()
        return player
    }
    
    func getArrayOfMatchSoundPlayers() -> [AVAudioPlayer]{
        var result:[AVAudioPlayer] = []
        for name in SoundAPI.allMatchSounds{
            result.append(soundNameToAudioPlayer(name))
        }
        config()
        return result
    }
    func getArrayOfFightSoundPlayers() -> [AVAudioPlayer]{
        var result:[AVAudioPlayer] = []
        for name in SoundAPI.allFightSounds{
            result.append(soundNameToAudioPlayer(name))
        }
        config()
        return result
    }
    
    func playVictorySound(){
        config()
        soundNameToAudioPlayer(SoundAPI.victorySound).play()
    }
    func playLossSound(){
            config()
            soundNameToAudioPlayer(SoundAPI.lossSound).play()
    }
    
    func playNotificationSound(){
        config()
        soundNameToAudioPlayer(SoundAPI.notificationSound).play()
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
    func getTargetLockedSound() -> AVAudioPlayer{
        return soundNameToAudioPlayer(SoundAPI.targetLockedSound)
    }
    func getMaleGruntSound() -> AVAudioPlayer{
        let name = SoundAPI.maleGruntSounds.randomItem()
        return soundNameToAudioPlayer(name)
    }
    func getFemaleGruntSound() -> AVAudioPlayer{
        let name = SoundAPI.femaleGruntSounds.randomItem()
        return soundNameToAudioPlayer(name)
    }
    func getDieSound() -> AVAudioPlayer{
        let name = SoundAPI.dieSound
        return soundNameToAudioPlayer(name)
    }
    func getGruntSoundForUser(user:PFUser) -> AVAudioPlayer{
        if let userGender = user.objectForKey("gender") as? String{
            if (userGender == "male"){
                return getMaleGruntSound()
            }
            else{
                return getFemaleGruntSound()
            }
                
        }
        // hashtag invisible patriarchy
        else{
            return getFemaleGruntSound()
        }
    }
}
