//
//  ViewController.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 9/14/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit
import AVKit


protocol FaceDelegate {
    func handleSwipeUp()
    func handleSwipeDown()
    func handleSwipeLeft()
    func handleSwipeRight()
}

class Face: UIViewController {
    
    
    @IBOutlet weak var videoLabel: UILabel!
    
    var swipeDown : UISwipeGestureRecognizer!
    
    var swipeUp : UISwipeGestureRecognizer!
    
    var swipeRight: UISwipeGestureRecognizer!
    
    var swipeLeft : UISwipeGestureRecognizer!
    
    var twoFingerTap : UITapGestureRecognizer!
    
    var tap : UITapGestureRecognizer!
    
    var longPress : UILongPressGestureRecognizer!
    
    var videoAnimationView : UIView!
    
    var videoLayer : AVPlayerLayer?
    
    static let viewDidLoadNotification = Notification.Name("ViewControllerViewDidLoad")

    var delegate : FaceDelegate?

    
    func dispatchText(_ string:String, for seconds:Double = 3.0){
        DispatchQueue.main.async {
            self.videoLabel.text = string
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
                self.videoLabel.text = ""
            })
        }
    }
    
    @objc func handleSwipeUp(_ gestureRecognizer:UISwipeGestureRecognizer){
        // MARK: Change video category
        delegate?.handleSwipeUp()
        
        
    }
    
    @objc func handleSwipeDown(_ gestureRecognizer:UISwipeGestureRecognizer){
        // MARK: Change video category
        
        delegate?.handleSwipeDown()
    }
    
    @objc func handleSwipeLeft(_ gestureRecognizer:UISwipeGestureRecognizer){
        
        delegate?.handleSwipeLeft()
        
    }
    
    @objc func handleSwipeRight(_ gestureRecognizer:UISwipeGestureRecognizer){
        
        delegate?.handleSwipeRight()
        
    }

    func setLayerPlayerLooper(_ player:AVQueuePlayer) {
        self.videoLayer?.removeFromSuperlayer()
        videoLayer? = AVPlayerLayer(player: player)
        self.view.layer.addSublayer(videoLayer!)
        videoLayer?.frame = self.view.frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.post(name: Face.viewDidLoadNotification, object: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

