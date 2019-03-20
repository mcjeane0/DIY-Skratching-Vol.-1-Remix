//
//  ViewController.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 9/14/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit
import AVKit


@objc protocol FaceDelegate {
    @objc optional func handleTrackButtonTapped()
    @objc optional func handleSyncButtonTapped()
    @objc optional func handlePlayPauseButtonTapped()
    @objc optional func handleRewindButtonTapped()
    @objc optional func handleBattleButtonTapped()
    @objc optional func handleDemoButtonTapped()
    @objc optional func handleTempoButtonTapped()
    @objc optional func handleFastForwardButtonTapped()
    @objc optional func handleStopButtonTapped()
    @objc optional func handleDifficultyButtonTapped()
    @objc optional func handlePointsButtonTapped()
    @objc optional func handleLoopButtonTapped()
    @objc optional func handleScratchButtonTapped()
}


class Face: UIViewController {
    
    
    
    @IBOutlet weak var videoView: UIView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var videoLabel: UILabel!
    
    var videoAnimationView : UIView!
    
    var videoLayer : AVPlayerLayer = AVPlayerLayer(player: nil)
    
    static let didAppearNotification = Notification.Name("FaceDidAppear")
    
    var delegate : FaceDelegate?

   

    func setLayerPlayerLooper(_ player:AVQueuePlayer) {
        videoLayer.player = player
        self.videoView.layer.addSublayer(videoLayer)
    }

    var viewCenter : CGPoint!
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillLayoutSubviews() {
        self.videoLabel.frame = self.view.bounds
        self.videoView.frame = self.view.bounds
        videoLayer.frame = self.videoView.frame
        viewCenter = view.center
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Face.didAppearNotification, object: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

