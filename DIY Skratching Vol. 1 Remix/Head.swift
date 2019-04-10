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
import AVKit
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
        quarterNoteMetronome.pause()
        infinitePeriodicTimer.pause()
        DispatchQueue.main.async {
            self.face.playPause.setTitle("Play", for: UIControl.State.normal)
        }
    }
    
    func resetTimer(){
        quarterNoteMetronome.reset(nil)
        infinitePeriodicTimer.reset(nil)
        infinitePeriodicTimer.start()
        quarterNoteMetronome.start()
        DispatchQueue.main.async {
            self.face.playPause.setTitle("Pause", for: UIControl.State.normal)
        }
    }
    
    func pausePlayer(){
        player.pause()

    }
    
    func playPlayer(){
        self.player.play()
        achieveDesiredTempo()
    }
    
    func handlePlayPauseButtonTapped() {
        switch infinitePeriodicTimer.state {
        case .paused:
            resetTimer()
            face.secondTimer.start()
            switch player.rate > 0 {
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
            switch player.rate > 0 {
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
        let milliInterval : Int = (period/1000000)*4
        let quarterMilliInterval = Repeater.Interval.milliseconds(period/1000000)
        let interval = Repeater.Interval.milliseconds(milliInterval)
        //Repeater.Interval.milliseconds(4*period/1000) 
        
        DispatchQueue.main.async {
            //self.playerItems.first!.seek(to: CMTime(value: 34961, timescale: 1000), toleranceBefore: self.aMilli, toleranceAfter: self.aMilli)
            self.quarterNoteMetronome.reset(quarterMilliInterval)
            self.infinitePeriodicTimer.reset(interval)
        }
        
    }
    
    func handlePhraseButtonTapped(count: Int) {
        desiredPhrase = count
        currentPhrase = 1
    }
    
    func handleDifficultyButtonTapped(){
        self.difficultyIndex++
        DispatchQueue.main.async {
            self.face.difficulty.setTitle("Level:\(self.difficultyIndex.rawValue)", for: UIControl.State.normal)
        }
    }
    
    func handleModulateButtonTapped(){
        
    }
    
    func handleSyncButtonTapped() {
        
    }
    
    func handleDemoButtonTapped() {
        
    }
    
    func handleLoopButtonTapped() {
        
    }
    
    func handleSliderChanged(value: Float) {
        
    }
    
    
}
