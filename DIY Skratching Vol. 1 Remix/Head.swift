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

extension Head {
    
    @objc func faceDidAppear(_ notification:Notification){
        if let viewController = notification.object as? Face {
            viewController.delegate = self
            self.face = viewController
            switch play {
            case .appDownloadedFromAppStore:
                
                break
            default:
                break
            }
            
        }
    }
    
    
}
