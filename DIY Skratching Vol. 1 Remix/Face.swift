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
    func handleTwoFingerLongPress()
}

class Face: UIViewController, UIGestureRecognizerDelegate {
    
    
    var twoFingerLongPress : UILongPressGestureRecognizer!
    
    @IBOutlet weak var videoView: UIView!
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
    
    
    @objc func handleTwoFingerLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
            break
        case .ended,.cancelled:
            break
        default:
            break
        }
        
    }

    func disableThreeFingerTap(){
        threeFingerTap.isEnabled = false
    }
    
    func enableThreeFingerTap(){
        threeFingerTap.isEnabled = true
        
    }
    
    func disableTwoFingerTap(){
        twoFingerTap.isEnabled = false
    }
    
    func enableTwoFingerTap(){
        twoFingerTap.isEnabled = true
    }
    
    func disableOneFingerTap(){
        tap.isEnabled = false
    }
    
    func enableOneFingerTap(){
        tap.isEnabled = true
    }
    
    func enableTaps(){
        enableOneFingerTap()
        enableTwoFingerTap()
        enableThreeFingerTap()
    }
    
    func disableTaps(){
        disableOneFingerTap()
        disableTwoFingerTap()
        disableThreeFingerTap()
    }
    
    func enableHorizontalSwipes(){
        enableSwipeLeft()
        enableSwipeRight()
    }
    
    func disableHorizontalSwipes(){
        disableSwipeLeft()
        disableSwipeRight()
    }
    
    func enableVerticalSwipes(){
        enableSwipeUp()
        enableSwipeDown()
    }
    
    func disableVerticalSwipes(){
        disableSwipeDown()
        disableSwipeUp()
    }
    
    func enableSwipeRight(){
        swipeRight.isEnabled = true
    }
    
    func disableSwipeRight(){
        swipeRight.isEnabled = false
    }
    
    func enableSwipeLeft(){
        swipeLeft.isEnabled = true
    }
    
    func disableSwipeLeft(){
        swipeLeft.isEnabled = false
    }
    
    func enableSwipeUp(){
        swipeUp.isEnabled = true
    }
    
    func disableSwipeUp(){
        swipeUp.isEnabled = false
    }
    
    func enableSwipeDown(){
        swipeDown.isEnabled = true
    }
    
    func disableSwipeDown(){
        swipeDown.isEnabled = false
    }
    
    func disableSwipes(){
        swipeUp.isEnabled = false
        swipeDown.isEnabled = false
        swipeLeft.isEnabled = false
        swipeRight.isEnabled = false
    }
    
    func enableSwipes(){
        swipeUp.isEnabled = true
        swipeDown.isEnabled = true
        swipeLeft.isEnabled = true
        swipeRight.isEnabled = true
    }
    
    func disableAllGestures(){
        disableSwipes()
        disableTaps()
        disablePinch()
    }
    
    func enableAllGestures(){
        enableSwipes()
        enableTaps()
        enablePinch()
    }
    
    func enablePinch(){
        pinch.isEnabled = true
    }
    
    func disablePinch(){
        pinch.isEnabled = false
    }
    
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
    
    
    
    func dispatchText(_ string:String, for seconds:Double=60.0){
        UIView.transition(with: videoLabel, duration: 0.0, options: .curveEaseIn, animations: {
            let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                .strokeColor : UIColor.black,
                .foregroundColor : UIColor.white,
                .strokeWidth : -2.0,
                ]
            
            self.videoLabel.attributedText = NSAttributedString(string: string, attributes: strokeTextAttributes)
            self.videoLabel.alpha = 1.0
        }) { (completed) in
            UIView.transition(with: self.videoLabel, duration: seconds, options: .curveEaseOut, animations: {
                self.videoLabel.alpha = 0.01
            }, completion: nil)
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

        //view.addGestureRecognizer(twoFingerTap)
        //view.addGestureRecognizer(tap)
        //view.addGestureRecognizer(threeFingerTap)
        //view.addGestureRecognizer(pinch)
        //view.addGestureRecognizer(swipeUp)
        //view.addGestureRecognizer(swipeDown)
        //view.addGestureRecognizer(swipeLeft)
        //view.addGestureRecognizer(swipeRight)
        //view.addGestureRecognizer(pan)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

