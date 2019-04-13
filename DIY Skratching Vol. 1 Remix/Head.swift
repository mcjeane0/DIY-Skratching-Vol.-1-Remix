//
//  Head.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 3/18/19.
//  Copyright © 2019 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation
import UIKit
import AVKit
typealias Head = QBot

extension Head : FaceDelegate {
    
    
    
    func pausePlayer(){
        player.pause()
        face.playPause.isHidden = false

    }
    
    func playPlayer(){
        self.player.play()
        achieveDesiredTempo()
        face.playPause.isHidden = true
    }
    
    func handlePlayPauseButtonTapped() {
        switch player.rate > 0 {
        case true:
            pausePlayer()
            break
        case false:
            playPlayer()
            break
        }
    }
    
    
    
}
