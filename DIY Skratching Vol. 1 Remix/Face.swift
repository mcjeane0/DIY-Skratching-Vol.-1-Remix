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

func currentNanoseconds()->Int{
    var info = mach_timebase_info()
    guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }
    let currentTime = mach_absolute_time()
    let nanos = currentTime * UInt64(info.numer) / UInt64(info.denom)
    return Int(nanos)
}

@objc protocol FaceDelegate {
    @objc optional func handleTrackButtonTapped()
    @objc optional func handleSyncButtonTapped()
    func handlePlayPauseButtonTapped()
    @objc optional func handleRewindButtonTapped()
    @objc optional func handleBattleButtonTapped()
    @objc optional func handleDemoButtonTapped()
    func handleTempoButtonTapped(bpm:Float, period:Int)
    func handlePhraseButtonTapped(count:Int)
    @objc optional func handleFastForwardButtonTapped()
    @objc optional func handleStopButtonTapped()
    func handleDifficultyButtonTapped()
    @objc optional func handlePointsButtonTapped()
    @objc optional func handleLoopButtonTapped()
    @objc optional func handleScratchButtonTapped()
}


class Face: UIViewController {
    
    @IBAction func difficultyButtonTapped(_ sender: Any) {
        delegate?.handleDifficultyButtonTapped()
    }
    
    
    @IBOutlet weak var difficulty: UIButton!
    
    var totalTime = 0
    
    lazy var secondTimer = Repeater.every(Repeater.Interval.seconds(1.0)) { (timer) in
        self.totalTime += 1
        let h = self.totalTime / 3600;
        let m = (self.totalTime / 60) % 60;
        let s = self.totalTime % 60;
        
        let formattedTime = String(format:"%u:%02u:%02u", h, m, s)
        DispatchQueue.main.async {
            self.time.setTitle(formattedTime, for: UIControl.State.normal)
        }
    }
    
    @IBOutlet weak var time: UIButton!
    
    @IBOutlet weak var points: UIButton!
    
    @IBOutlet weak var phrase: UIButton!
    
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var zero: UIButton!
    @IBOutlet weak var nine: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var six: UIButton!
    
    
    @IBAction func tappedNumeric(_ sender: UIButton) {
        
        if let title = sender.title(for: .normal) {
            digitComponents.append(title)
            if digitComponents.count > 3 {
                digitComponents.removeFirst()
            }
            let bpm = Float(digitComponents.joined())!
            DispatchQueue.main.async {
                self.selectedButton.setTitle("\(bpm)", for: UIControl.State.normal)
            }
        }
        
    }
    
    var selectedButton : UIButton!
    
    @IBOutlet weak var tempo: UIButton!
    
    var digitComponents : [String] = []
    
    var numericKeypadDisplayed = false
    
    func hideNumeric(){
        one.isHidden = true
        two.isHidden = true
        three.isHidden = true
        four.isHidden = true
        five.isHidden = true
        six.isHidden = true
        seven.isHidden = true
        eight.isHidden = true
        nine.isHidden = true
        zero.isHidden = true
        numericKeypadDisplayed = false
    }
    
    func showNumeric(){
        one.isHidden = false
        two.isHidden = false
        three.isHidden = false
        four.isHidden = false
        five.isHidden = false
        six.isHidden = false
        seven.isHidden = false
        eight.isHidden = false
        nine.isHidden = false
        zero.isHidden = false
        numericKeypadDisplayed = true
    }
    
    @IBAction func tempoTapped(_ sender: Any) {
        
        if numericKeypadDisplayed && selectedButton == tempo{
            if digitComponents.count > 0 {
                let bpm = Float(digitComponents.joined())!
                let roundedPeriod = Int((60.0/bpm)*1000000000)
                DispatchQueue.main.async {
                    self.tempo.setTitle("\(bpm)", for: UIControl.State.normal)
                }
                delegate?.handleTempoButtonTapped(bpm: bpm, period: roundedPeriod)
            }
            
            hideNumeric()
            digitComponents.removeAll()
        }
        else if !numericKeypadDisplayed {
            selectedButton = tempo
            showNumeric()
        }
        
    }
    
    @IBAction func phraseTapped(_sender: Any) {
        
        if numericKeypadDisplayed && selectedButton == phrase{
            if digitComponents.count > 0 {
                let phraseCount = Float(digitComponents.joined())!
                
                DispatchQueue.main.async {
                    self.phrase.setTitle("\(phraseCount)", for:UIControl.State.normal)
                }
                delegate?.handlePhraseButtonTapped(count:Int(phraseCount))
            }
            
            hideNumeric()
            digitComponents.removeAll()
        }
        else if !numericKeypadDisplayed {
            selectedButton = phrase
            showNumeric()
        }
        
    }
    
    @IBOutlet weak var playPause: UIButton!
    
    @IBAction func playPauseTapped(_ sender: Any) {
     
        delegate?.handlePlayPauseButtonTapped()
        //add metronome click
        
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
        self.videoView.frame = self.view.bounds
        /*
        switch UIDevice.current.orientation {
        case .landscapeLeft,.landscapeRight:
            self.videoView.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width/2.0, height: self.view.frame.height))
            break
        default:
            self.videoView.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height/2.0))
        }
        */
        videoLayer.frame = self.videoView.frame
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Face.didAppearNotification, object: self)
        secondTimer.start()
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

