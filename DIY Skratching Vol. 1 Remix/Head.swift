//
//  Head.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 3/18/19.
//  Copyright © 2019 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation
import UIKit
import Repeat
typealias Head = QBot

extension Head : FaceDelegate {
    
    func playPause(_ global:Bool){
        if queuePlayer.rate > 0.0 {
            queuePlayer.pause()
            if global {
                infinitePeriodicTimer.pause()
                DispatchQueue.main.async {
                    self.face.playPause.setTitle("Play", for: UIControl.State.normal)
                }

            }
            
        }
        else {
            if !self.answering {
            queuePlayer.play()
            }
            if global {
                infinitePeriodicTimer.reset(nil)
                infinitePeriodicTimer.start()
                DispatchQueue.main.async {
                    self.face.playPause.setTitle("Pause", for: UIControl.State.normal)
                }
            }
            achieveDesiredTempo()
        }
    }
    
    func handlePlayPauseButtonTapped() {
        playPause(true)
    }
    
    func handleTempoButtonTapped(bpm: Float, period:Int) {
        desiredTempo = bpm
        achieveDesiredTempo()
        infinitePeriodicTimer.reset(Repeater.Interval.nanoseconds(4*period))
        
    }
    
    func handlePhraseButtonTapped(count: Int) {
        desiredPhrase = count
        currentPhrase = 1
    }
    
    
}
