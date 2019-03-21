//
//  ThudRumbleVideoClip.swift
//  Q-Bot
//
//  Created by Arjun Iyer on 3/21/19.
//  Copyright © 2019 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation
import AVFoundation

class ThudRumbleVideoClip {
    
    var name : String
    var loop : CMTimeRange?
    var angles : [ThudRumbleVideoClip]
    var tracks : [String]
    var url : URL
    var rate : Float {
        get {
            let value = UserDefaults.standard.float(forKey: "\(name)Rate")
            if value == 0.0 {
                UserDefaults.standard.set(1.0, forKey:name)
                return 1.0
            }
            return value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(name)Rate")
        }
    }
    var pitchAlgorithm : AVAudioTimePitchAlgorithm {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: Key.pitchAlgorithm.rawValue){
                return AVAudioTimePitchAlgorithm(rawValue: rawValue)
            }
            return AVAudioTimePitchAlgorithm.varispeed
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Key.pitchAlgorithm.rawValue)
        }
    }
    
    init(name:String,loop:CMTimeRange?,angles:[ThudRumbleVideoClip],tracks:[String],url:URL){
        self.name = name
        self.loop = loop
        self.angles = angles
        self.tracks = tracks
        self.url = url
        
    }
    
}
