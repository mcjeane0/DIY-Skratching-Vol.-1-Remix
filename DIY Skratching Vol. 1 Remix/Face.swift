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
    func handlePlayPauseButtonTapped()
    @objc optional func handleRewindButtonTapped()
    @objc optional func handleBattleButtonTapped()
    @objc optional func handleDemoButtonTapped()
    func handleTempoButtonTapped(bpm:Float, period:Int)
    @objc optional func handleFastForwardButtonTapped()
    @objc optional func handleStopButtonTapped()
    @objc optional func handleDifficultyButtonTapped()
    @objc optional func handlePointsButtonTapped()
    @objc optional func handleLoopButtonTapped()
    @objc optional func handleScratchButtonTapped()
}


class Face: UIViewController {
    
    @IBOutlet weak var tempo: UIButton!
    
    func currentNanoseconds()->Int{
        var info = mach_timebase_info()
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }
        let currentTime = mach_absolute_time()
        let nanos = currentTime * UInt64(info.numer) / UInt64(info.denom)
        return Int(nanos)
    }
    
    var lastTempoTapped : Int = 0
    
    @IBAction func tempoTapped(_ sender: Any) {
        
        let currentTempoTapped = currentNanoseconds()
        let intPeriod = currentTempoTapped - lastTempoTapped > 2000000000 ? 2000000000 : currentTempoTapped - lastTempoTapped
        lastTempoTapped = currentTempoTapped
        let period = Float(intPeriod)
        let frequency : Float = 1000000000.0/period
        let bpm = frequency * 60.0
        let roundedBPM = String.localizedStringWithFormat(format:"%.2f",bpm)
        tempo.setTitle(roundedBPM, for: UIControl.State.normal)
        delegate?.handleTempoButtonTapped(bpm: bpm, period: intPeriod)
        
    }
    
    @IBOutlet weak var playPause: UIButton!
    
    @IBAction func playPauseTapped(_ sender: Any) {
     
        delegate?.handlePlayPauseButtonTapped()
        
    }
    
    @IBOutlet weak var videoView: UIView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var videoLabel: UILabel!
    
    var videoAnimationView : UIView!
    
    var videoLayer : AVPlayerLayer = AVPlayerLayer(player: nil)
    
    static let didAppearNotification = Notification.Name("FaceDidAppear")
    
    var delegate : FaceDelegate?



    func setLayerPlayer(_ player:AVQueuePlayer) {
        videoLayer.player = player
        self.videoView.layer.addSublayer(videoLayer)
    }

    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillLayoutSubviews() {
        self.videoLabel.frame = self.view.bounds
        switch UIDevice.current.orientation {
        case .landscapeLeft,.landscapeRight:
            self.videoView.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width/2.0, height: self.view.frame.height))
            break
        default:
            self.videoView.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height/2.0))
        }
        videoLayer.frame = self.videoView.frame
        
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

