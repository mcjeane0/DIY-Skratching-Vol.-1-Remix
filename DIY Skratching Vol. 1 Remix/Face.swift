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
    func handleTwoFingerTap()
    func handleTap()
    func handleLongPress()
}

class Face: UIViewController : UIGestureRecognizerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var videoLabel: UILabel!
    
    var swipeDown : UISwipeGestureRecognizer!
    
    var swipeUp : UISwipeGestureRecognizer!
    
    var swipeRight: UISwipeGestureRecognizer!
    
    var swipeLeft : UISwipeGestureRecognizer!
    
    var twoFingerTap : UITapGestureRecognizer!
    
    var tap : UITapGestureRecognizer!
    
    var longPress : UILongPressGestureRecognizer!
    
    var videoAnimationView : UIView!
    
    var videoLayer : AVPlayerLayer = AVPlayerLayer(player: nil)
    
    static let didAppearNotification = Notification.Name("FaceDidAppear")

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
        videoLayer.player = player
        self.view.layer.addSublayer(videoLayer)
    }

    override func viewWillLayoutSubviews() {
        videoLayer.frame = self.view.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Face.didAppearNotification, object: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp(_:)))
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

