//
//  Head.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 3/18/19.
//  Copyright © 2019 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation
import UIKit

typealias Head = QBot

extension Head : FaceDelegate {
    
    @objc func faceDidAppear(_ notification:Notification){
        if let viewController = notification.object as? Face {
            viewController.delegate = self
            self.face = viewController
            switch play {
            case .appDownloadedFromAppStore:
                face.disableAllGestures()
                appDownloadedFromAppStoreAlert()
                break
            default:
                loadVideoAtFaceIndexPath()
                break
            }
            
        }
    }
    
    
    func handleTwoFingerLongPress() {
        
    }
    
    func handlePinch(_ gestureRecognizer:UIPinchGestureRecognizer){
        
        switch gestureRecognizer.state {
        case .ended:
            
            /*
            DispatchQueue.main.async {
                
                
                
                if let currentRate = self.queuePlayer?.rate {
                    let product = self.pinchFactor
                    let lessThanMaximumProduct = product > 1.25 ? 1.25 : product
                    let greaterThanMinimumAndLessThanMaximumProduct = product < 0.1 ? 0.1 : product
                    self.playbackRate = Float(greaterThanMinimumAndLessThanMaximumProduct)
                    //let nextRate = greaterThanMinimumAndLessThanMaximumProduct
                    //self.queuePlayer?.rate = nextRate
                    self.face.dispatchText("📶", for: 3.0)
                    
                    switch self.play {
                    case .beginningPinchOut:
                        if self.pinchFactor >= 1.0 {
                            Play.firstPinchIn.markFinished()
                            self.completedPinchOutTutorialAlert()
                        }
                        break
                    case .beginningPinchIn:
                        if self.pinchFactor <= 1.0 {
                            Play.firstPinchOut.markFinished()
                            self.completedPinchInTutorialAlert()
                        }
                        break
                    default:
                        break
                    }
                    
                }
            }
            */
            break
        default:
            break
        }
        
    }
    
    func handleFourFingerTap(){
        
        
    }
    
    func handleThreeFingerTap(){
        if lastVideoWatched == lastSkratchVideo {
            let nextTrack = selectedTrack + 1 > 3 ? 1 : selectedTrack + 1
            selectedTrack = nextTrack
            loadTrackForVideo(nextTrack)
            switch nextTrack {
            case 1:
                face.dispatchText("1️⃣", for: 3.0)
                break
            case 2:
                face.dispatchText("2️⃣", for: 3.0)
                break
            case 3:
                face.dispatchText("3️⃣", for: 3.0)
                break
            default:
                break
            }
            
            switch play {
            case .beginningThreeFingerTap:
                Play.firstThreeFingerTap.markFinished()
                self.completedThreeFingerTapTutorialAlert()
                break
            default:
                break
            }
            
        }
    }
    
    func handleTwoFingerTap() {
        face.dispatchText("🎦", for: 0.5)
        if lastVideoWatched == lastSkratchVideo {
            let nextAngle = selectedAngle + 1 > 4 ? 1 : selectedAngle + 1
            selectedAngle = nextAngle
            
            DispatchQueue.main.async {
                let seekToTime = self.queuePlayer?.currentTime()
                self.queuePlayer?.pause()
                self.loadVideoAtFaceIndexPath()
                if seekToTime != nil {
                    self.queuePlayer?.pause()
                    self.queuePlayer?.seek(to: seekToTime!)
                    self.queuePlayer?.play()
                    self.queuePlayer?.rate = self.playbackRate
                }
            }
            switch play {
            case .beginningTwoFingerTap:
                Play.firstTwoFingerTap.markFinished()
                self.completedTwoFingerTapTutorialAlert()
                break
            default:
                break
            }
        }
    }
    
    func handleLongPress() {
        
    }
    
    func handleTap() {
        if let rate = queuePlayer?.rate, rate > 1/64 {
            queuePlayer?.pause()
            face.dispatchText("⏸", for: 3.0)
        }
        else {
            queuePlayer?.play()
            DispatchQueue.main.async {
                self.queuePlayer?.rate = self.playbackRate
            }
            face.dispatchText("▶️", for: 3.0)
        }
        switch play {
        case .beginningOneFingerTap:
            Play.firstOneFingerTap.markFinished()
            self.completedOneFingerTapTutorialAlert()
            break
        default:
            break
        }
    }
    
    func handleSwipeUp() {
        face.dispatchText("⏫", for: 3.0)
        let maxSectionIndex = sections.count - 1
        let incrementedSectionIndex = self.faceIndexPath.section + 1
        let nextPossibleSectionIndex = incrementedSectionIndex > maxSectionIndex ? 0 : incrementedSectionIndex
        let nextSection = sections[nextPossibleSectionIndex]
        switch nextSection {
        case Key.Skratches.rawValue:
            let rowIndex = skratchNames.firstIndex(of: lastSkratchVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        case Key.Battles.rawValue:
            //selectedAngle = 1
            //selectedTrack = 1
            let rowIndex = battleNames.firstIndex(of: lastBattleVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        case Key.EquipmentSetup.rawValue:
            //selectedAngle = 1
            //selectedTrack = 1
            let rowIndex = equipmentSetupNames.firstIndex(of: lastEquipmentSetupVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        default:
            break
        }
        
        loadVideoAtFaceIndexPath()
        
        switch play {
        case .beginningVerticalSwipesTutorial:
            Play.firstSwipeUp.markFinished()
            completedVerticalSwipesAlert()
            break
        default:
            break
        }
        
    }
    
    func handleSwipeDown() {
        face.dispatchText("⏬", for: 3.0)
        let maxSectionIndex = sections.count - 1
        let decrementedSectionIndex = self.faceIndexPath.section - 1
        let nextPossibleSectionIndex = decrementedSectionIndex < 0 ? maxSectionIndex : decrementedSectionIndex
        let nextSection = sections[nextPossibleSectionIndex]
        switch nextSection {
        case Key.Skratches.rawValue:
            let rowIndex = skratchNames.firstIndex(of: lastSkratchVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        case Key.Battles.rawValue:
            //selectedAngle = 1
            //selectedTrack = 1
            let rowIndex = battleNames.firstIndex(of: lastBattleVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        case Key.EquipmentSetup.rawValue:
            //selectedAngle = 1
            //selectedTrack = 1
            let rowIndex = equipmentSetupNames.firstIndex(of: lastEquipmentSetupVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        default:
            break
        }
        
        loadVideoAtFaceIndexPath()
        switch play {
        case .beginningVerticalSwipesTutorial:
            Play.firstSwipeDown.markFinished()
            completedVerticalSwipesAlert()
            break
        default:
            break
        }
    }
    
    func handleSwipeLeft() {
        face.dispatchText("⏮", for: 3.0)
        let currentSection = sections[self.faceIndexPath.section]
        let maxItemCount = videos[currentSection]!.count-1
        let incrementedIndex = self.faceIndexPath.row + 1
        let nextPossibleRowIndex = incrementedIndex > maxItemCount ? 0 : incrementedIndex
        
        faceIndexPath = IndexPath(row: nextPossibleRowIndex, section: self.faceIndexPath.section)
        loadVideoAtFaceIndexPath()
        switch play {
        case .beginningHorizontalSwipesTutorial:
            Play.firstSwipeLeft.markFinished()
            completedHorizontalSwipesAlert()
            break
        default:
            break
        }
    }
    
    func handleSwipeRight() {
        face.dispatchText("⏭", for: 3.0)
        let currentSection = sections[self.faceIndexPath.section]
        let maxItemCount = videos[currentSection]!.count - 1
        let decrementedIndex = self.faceIndexPath.row - 1
        let nextPossibleRowIndex = decrementedIndex < 0 ? maxItemCount : decrementedIndex
        
        faceIndexPath = IndexPath(row: nextPossibleRowIndex, section: self.faceIndexPath.section)
        loadVideoAtFaceIndexPath()
        switch play {
        case .beginningHorizontalSwipesTutorial:
            Play.firstSwipeRight.markFinished()
            completedHorizontalSwipesAlert()
            break
        default:
            break
        }
        
    }
    
}
