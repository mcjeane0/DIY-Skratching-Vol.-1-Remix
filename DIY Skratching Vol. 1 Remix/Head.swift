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
    
    func globalPause(){
        pausePlayer()
        pauseTimer()
    }
    
    func globalPlay(){
        playPlayer()
        resetTimer()
    }
    
    func pauseTimer(){
        infinitePeriodicTimer.pause()
        DispatchQueue.main.async {
            self.face.playPause.setTitle("Play", for: UIControl.State.normal)
        }
    }
    
    func resetTimer(){
        infinitePeriodicTimer.reset(nil)
        infinitePeriodicTimer.start()
        DispatchQueue.main.async {
            self.face.playPause.setTitle("Pause", for: UIControl.State.normal)
        }
    }
    
    func pausePlayer(){
        queuePlayer.pause()

    }
    
    func playPlayer(){
        self.queuePlayer.play()
        achieveDesiredTempo()
    }
    
    func handlePlayPauseButtonTapped() {
        switch infinitePeriodicTimer.state {
        case .paused:
            resetTimer()
            face.secondTimer.start()
            switch queuePlayer.rate > 0 {
            case true:
                break
            case false:
                playPlayer()
                break
            }
            break
        case .running,.executing,.finished:
            pauseTimer()
            face.secondTimer.pause()
            switch queuePlayer.rate > 0 {
            case true:
                pausePlayer()
                break
            case false:
                break
            }
            break
        }
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
