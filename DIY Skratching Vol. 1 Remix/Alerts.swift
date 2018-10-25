//
//  Alerts.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 10/24/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation
import UIKit

extension QBot {
    
    func appDownloadedFromAppStoreAlert(){
        Play.firstSwipeUp.markUnfinished()
        Play.firstOneFingerTap.markUnfinished()
        Play.firstPinchIn.markUnfinished()
        let welcomeAlert = UIAlertController(title: "Hello", message: "Would you like a brief tutorial on how to use this app?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.play = .beginningTutorial
            self.beginningTutorialAlert()
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (action) in
            self.play = .training
            self.loadVideoAtFaceIndexPath()
        }
        welcomeAlert.addAction(yesAction)
        welcomeAlert.addAction(noAction)
        face.present(welcomeAlert, animated: true, completion: nil)
    }
    
    func beginningTutorialAlert(){
        let alert = UIAlertController(title: "So you want to learn how to scratch?", message: "Well first, you need to learn some gestures. What would you like to learn?", preferredStyle: .alert)
        let tapsAction = UIAlertAction(title: "Taps", style: .default) { (action) in
            self.play = .beginningTapsTutorial
            self.beginningTapsTutorialAlert()
        }
        let swipesAction = UIAlertAction(title: "Swipes", style: .default) { (action) in
            self.play = .beginningSwipesTutorial
            self.beginningSwipesTutorialAlert()
        }
        let pinchAction = UIAlertAction(title: "Pinches", style: .default) { (action) in
            self.play = .beginningPinchesTutorial
            self.beginningPinchesTutorialAlert()
        }
        if !Play.firstSwipeUp.isFinished() {
            alert.addAction(swipesAction)

        }
        if !Play.firstOneFingerTap.isFinished(){
            alert.addAction(tapsAction)

        }
        
        if !Play.firstPinchIn.isFinished(){
            alert.addAction(pinchAction)

        }
        if alert.actions.count > 0 {
            DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
        }
        else {
            completedTutorialAlert()
        }
    }
    
    func beginningSwipesTutorialAlert(){
        let alert = UIAlertController(title: "Swipes", message: "Swipes are used to navigate videos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.enableVerticalSwipes()
            self.play = .beginningVerticalSwipesTutorial
            self.face.dispatchText("Try swiping up or down, with one finger")
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func completedVerticalSwipesAlert(){
        let alert = UIAlertController(title: "Swipe up or down to switch video categories", message: "There are two categories of videos: battles and scratches", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.disableVerticalSwipes()
            self.face.enableHorizontalSwipes()
            self.play = .beginningHorizontalSwipesTutorial
            self.face.dispatchText("Try swiping left or right, with one finger")
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
    }
    
    func completedHorizontalSwipesAlert(){
        let alert = UIAlertController(title: "Swipe left or right to change between videos in single category", message: "Videos are organized by skill levels", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.disableHorizontalSwipes()
            self.completedSwipesTutorialAlert()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func completedSwipesTutorialAlert(){
        let alert = UIAlertController(title: "You learned how to swipe!", message: "Now you know, swipes are for navigating videos", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes I do", style: .default) { (action) in
            self.beginningTutorialAlert()
        }
        alert.addAction(yesAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
    }
    
    func beginningTapsTutorialAlert(){
        let alert = UIAlertController(title: "Taps", message: "Taps are used to manipulate the current video", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.enableOneFingerTap()
            self.play = .beginningOneFingerTap
            self.face.dispatchText("Tap with one finger to pause and play the video")
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
    }
    
    func completedOneFingerTapTutorialAlert(){
        let alert = UIAlertController(title: "Two finger taps", message: "Two finger taps change the video angle for scratch videos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.disableOneFingerTap()
            self.face.enableTwoFingerTap()
            self.play = .beginningTwoFingerTap
            self.face.dispatchText("Tap with two fingers to change the video angle")
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }

    }
    
    
    func completedTwoFingerTapTutorialAlert(){
        let alert = UIAlertController(title: "Three finger taps", message: "A three-finger tap changes the audio track for scratch videos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.disableTwoFingerTap()
            self.face.enableThreeFingerTap()
            self.play = .beginningThreeFingerTap
            self.face.dispatchText("Tap with three fingers to change the audio tracks")
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }

    }
    
    
    func completedThreeFingerTapTutorialAlert(){
        let alert = UIAlertController(title: "You learned how to tap!", message: "Remember, taps are used to change the video and audio tracks for the current video", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.beginningTutorialAlert()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }

    }
    
    func beginningPinchesTutorialAlert(){
        let alert = UIAlertController(title: "Pinches", message: "Pinches change the playback rate of the current video.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.enablePinch()
            self.play = .beginningPinchIn
            self.face.dispatchText("Try pinching the screen, by placing two fingers on the screen, and sliding them towards each other")
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
    }
    
    func completedPinchInTutorialAlert(){
        let alert = UIAlertController(title: "You pinched the video!", message: "Pinching in causes the video to slow down", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.enablePinch()
            self.play = .beginningPinchOut
            self.face.dispatchText("Now try the opposite motion, moving your two fingers on the screen, and sliding them away from each other")
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
    }
    
    func completedPinchOutTutorialAlert(){
        let alert = UIAlertController(title: "You learned how to pinch!", message: "Don't forget: pinches are used to change the video's playback speed", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.face.disablePinch()
            self.beginningTutorialAlert()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
    }
    
    func completedTutorialAlert(){
        let alert = UIAlertController(title: "Wow you did it!", message: "That's the whole tutorial, are you ready to scratch?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.play = .training
            self.face.enableAllGestures()
            self.face.dispatchText("Have fun scratching!", for: 3.0)
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (action) in
            self.appDownloadedFromAppStoreAlert()
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        DispatchQueue.main.async {
            self.face.present(alert, animated: true, completion: nil)
        }
    }
    
}
