//
//  Play.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 10/20/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import Foundation


enum Play : String {
    
    case appDownloadedFromAppStore = "appDownloadedFromAppStore"
    case beginningTutorial = "beginningTutorial"
    case beginningSwipesTutorial = "beginningSwipesTutorial"
    case beginningVerticalSwipesTutorial = "beginningVerticalSwipesTutorial"
    case finishedVerticalSwipesTutorial = "finishedVerticalSwipesTutorial"
    case beginningHorizontalSwipesTutorial = "beginningHorizontalSwipesTutorial"
    case firstSwipeUp = "firstSwipeUp"
    case firstSwipeDown = "firstSwipeDown"
    case firstSwipeLeft = "firstSwipeLeft"
    case firstSwipeRight = "firstSwipeRight"
    case beginningTapsTutorial = "beginningTapsTutorial"
    case beginningOneFingerTap = "beginningOneFingerTap"
    case firstOneFingerTap = "firstOneFingerTap"
    case beginningTwoFingerTap = "beginningTwoFingerTap"
    case firstTwoFingerTap = "firstTwoFIngerTap"
    case beginningThreeFingerTap = "beginningThreeFingerTap"
    case firstThreeFingerTap = "firstThreeFingerTap"
    case beginningPinchesTutorial = "beginningPinchesTutorial"
    case beginningPinchIn = "beginningPinchIn"
    case firstPinchIn = "firstPinchIn"
    case beginningPinchOut = "beginningPinchOut"
    case firstPinchOut = "firstPinchOut"
    case finishedTutorial = "finishedTutorial"
    case training = "training"
    
    func finishedOnce()->Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }
    
    func markUnfinished(){
        UserDefaults.standard.set(false, forKey: self.rawValue)
    }
    
}
