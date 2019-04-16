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
        videoLayer.videoGravity = .resizeAspectFill
        self.videoView.layer.addSublayer(videoLayer)
        self.videoView.contentMode = .scaleToFill
    }
    
    func primaryHanded(){
        DispatchQueue.main.async {
            self.videoView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func secondaryHanded(){
        DispatchQueue.main.async {
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
        
        let orientation = UIDevice.current.orientation
        
        var layerRect : CGRect!
        
        switch orientation {
        case .portrait,.portraitUpsideDown:
            layerRect = CGRect(x: self.videoView.frame.origin.x-600.0, y: self.videoView.frame.origin.y, width: self.videoView.frame.height*960.0/540, height: self.videoView.frame.height)
            break
        case .landscapeLeft,.landscapeRight:
            layerRect = CGRect(x: self.videoView.frame.origin.x, y: self.videoView.frame.origin.y, width: self.videoView.frame.width, height: self.videoView.frame.height)
        default:
            layerRect = videoLayer.frame
            break
        }
        
        videoLayer.frame = layerRect
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Face.didAppearNotification, object: self)
    }


}

