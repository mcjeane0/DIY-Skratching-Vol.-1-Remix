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
    func handlePinch(_ gestureRecognizer:UIPinchGestureRecognizer)
    func handleSwipeUp()
    func handleSwipeDown()
    func handleSwipeLeft()
    func handleSwipeRight()
    func handleThreeFingerTap()
    func handleTwoFingerTap()
    func handleTap()
    func handleLongPress()
}

class Face: UIViewController, UIGestureRecognizerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var videoLabel: UILabel!
    
    var pan : UIPanGestureRecognizer!
    
    var pinch : UIPinchGestureRecognizer!
    
    var swipeDown : UISwipeGestureRecognizer!
    
    var swipeUp : UISwipeGestureRecognizer!
    
    var swipeRight: UISwipeGestureRecognizer!
    
    var swipeLeft : UISwipeGestureRecognizer!
    
    var threeFingerTap : UITapGestureRecognizer!
    
    var twoFingerTap : UITapGestureRecognizer!
    
    var tap : UITapGestureRecognizer!
    
    var longPress : UILongPressGestureRecognizer!
    
    var videoAnimationView : UIView!
    
    var videoLayer : AVPlayerLayer = AVPlayerLayer(player: nil)
    
    static let didAppearNotification = Notification.Name("FaceDidAppear")

    var delegate : FaceDelegate?

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == twoFingerTap && otherGestureRecognizer == pinch {
            return true
        }
        else if gestureRecognizer == threeFingerTap && otherGestureRecognizer == twoFingerTap {
            return true
        }
        else if gestureRecognizer == twoFingerTap && otherGestureRecognizer == tap {
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pan {
            return true
        }
        return false
    }
    
    func dispatchText(_ string:String, for seconds:Double = 3.0){
        DispatchQueue.main.async {
            self.videoLabel.text = string
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
                self.videoLabel.text = ""
            })
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer){
        switch gestureRecognizer.state {
        case .changed:
            let translation = gestureRecognizer.translation(in: self.view)
            UIView.animate(withDuration: 0.0) {
                self.view.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            }
            break
        case .ended:
            UIView.animate(withDuration: 0.2) {
                self.view.center = self.viewCenter
            }
        default:
            break
        }
    }

    @objc func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer){
        delegate?.handlePinch(gestureRecognizer)
    }
    
    @objc func handleThreeFingerTap(_ gestureRecognizer:UITapGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleThreeFingerTap()
            break
        default:
            break
        }
    }
    
    @objc func handleTwoFingerTap(_ gestureRecognizer:UITapGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleTwoFingerTap()
            break
        default:
            break
        }
    }
    
    @objc func handleTap(_ gestureRecognizer:UITapGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleTap()
            break
        default:
            break
        }
    }
    
    @objc func handleSwipeUp(_ gestureRecognizer:UISwipeGestureRecognizer){
        // MARK: Change video category
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleSwipeUp()

            break
        default:
            break
        }

        
        
    }
    
    @objc func handleSwipeDown(_ gestureRecognizer:UISwipeGestureRecognizer){
        // MARK: Change video category
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleSwipeDown()

            break
        default:
            break
        }
    }
    
    @objc func handleSwipeLeft(_ gestureRecognizer:UISwipeGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleSwipeLeft()

            break
        default:
            break
        }
        
    }
    
    @objc func handleSwipeRight(_ gestureRecognizer:UISwipeGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleSwipeRight()
            break
        default:
            break
        }
        
    }

    func setLayerPlayerLooper(_ player:AVQueuePlayer) {
        videoLayer.player = player
        self.view.layer.addSublayer(videoLayer)
    }

    var viewCenter : CGPoint!
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillLayoutSubviews() {
        videoLayer.frame = self.view.frame
        viewCenter = view.center

    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Face.didAppearNotification, object: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp(_:)))
        swipeUp.direction = .up
        swipeUp.delegate = self
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDown.direction = .down
        swipeDown.delegate = self
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRight.direction = .right
        swipeRight.delegate = self
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self

        twoFingerTap = UITapGestureRecognizer(target: self, action: #selector(handleTwoFingerTap(_:)))
        twoFingerTap.numberOfTouchesRequired = 2
        twoFingerTap.delegate = self

        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        
        threeFingerTap = UITapGestureRecognizer(target: self, action: #selector(handleThreeFingerTap(_:)))
        threeFingerTap.numberOfTouchesRequired = 3
        threeFingerTap.delegate = self
        
        
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinch.delegate = self
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

        view.addGestureRecognizer(twoFingerTap)
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(threeFingerTap)
        view.addGestureRecognizer(pinch)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
        //view.addGestureRecognizer(pan)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

