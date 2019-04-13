//
//  ViewController.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 9/14/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit
import AVKit
import Repeat
import VerticalSlider

@objc protocol FaceDelegate {
    func handlePlayPauseButtonTapped()
    
}


class Face: UIViewController {
    
    
    @IBOutlet weak var tempoLabel: UILabel!
    
    @IBOutlet weak var timeLeft: UILabel!
    
    
    @IBOutlet weak var playPause: UILabel!
    
    @IBOutlet weak var videoView: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var videoAnimationView : UIView!
    
    var videoLayer : AVPlayerLayer = AVPlayerLayer(player: nil)
    
    static let didAppearNotification = Notification.Name("FaceDidAppear")
    
    var delegate : FaceDelegate?
    
    @objc func handleTap(_ gestureRecognizer:UITapGestureRecognizer){
        self.delegate?.handlePlayPauseButtonTapped()
    }

    func setLayerPlayer(_ player:AVPlayer) {
        videoLayer.player = player
        self.videoView.layer.addSublayer(videoLayer)
    }
    
    func primaryHanded(){
        DispatchQueue.main.sync {
            self.videoView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func secondaryHanded(){
        DispatchQueue.main.sync {
            self.videoView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }

    override func viewWillLayoutSubviews() {
        self.videoView.frame = self.view.bounds
        
        videoLayer.frame = self.videoView.frame
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Face.didAppearNotification, object: self)
    }


}

