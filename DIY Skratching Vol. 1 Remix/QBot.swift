//
//  QBot.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 9/14/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

@UIApplicationMain

class QBot: UIResponder, UIApplicationDelegate {

    //got rid of all third party libraries
    
    var playerState : Play {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: Key.play.rawValue){
                if let ripeValue = Play(rawValue:rawValue) {
                    return ripeValue
                }
            }
            return .appDownloadedFromAppStore
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Key.play.rawValue)
        }
    }
    
    var state : State {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: Key.state.rawValue) {
                if let ripeValue = State(rawValue: rawValue) {
                    return ripeValue
                }
            }
            return .hello
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Key.state.rawValue)
        }
    }
    

    
    
    var speechSynthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    
    var face : Face!


    //var videos : [String:[ThudRumbleVideoClip]] = [Key.Skratches.rawValue:[], Key.Battles.rawValue:[]]
    var player : AVPlayer!
    var window: UIWindow?
    

    fileprivate func warpTimeForPlayerItem(_ newValue: Float) {
        let fractionRemaining = Double(remainingSecondsAtDesiredTempo)/Double(durationAtDesiredTempo)
        durationAtDesiredTempo = Int(ceil((newValue/79.0) * seventyNineBPMDuration))
        remainingSecondsAtDesiredTempo = Int(ceil(fractionRemaining * Double(durationAtDesiredTempo)))
    }
    
    var desiredTempo : Float {
        get {
            let existingFloat = UserDefaults.standard.float(forKey: "desiredTempo")
            return existingFloat <= 1.0 ? 79.0 : existingFloat
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "desiredTempo")
            face.tempoLabel.text = "\(newValue)"
            warpTimeForPlayerItem(newValue)
        }
    }
    
   
    
    let aMilli = CMTime(value: 1, timescale: 1000)
    
   
    
    var randomItem : AVPlayerItem!
    
    
    let seventyNineInterval = Int64((60.0/79.0*1000.0))

   
    
    func achieveDesiredTempo() {
        if self.player.rate > 0 {
            self.player.rate = (self.desiredTempo/79.0)

        }
       
    }
    
    var secondaryHand : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "secondaryHand")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "secondaryHand")
        }
    }
    
    var fastPractice : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "fastPractice")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "fastPractice")
        }
    }
    
    let seventyNineBPMDuration : Float = 2182.0
    
    var remainingSecondsAtDesiredTempo = 2182
    
    var durationAtDesiredTempo = 2182
    
    @objc func resetQBot(_ notification:Notification){
        DispatchQueue.main.async {
             self.player.currentItem!.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
            self.remainingSecondsAtDesiredTempo = self.durationAtDesiredTempo
            self.updateRemainingTime(self.timeRemainingTimer)
            self.secondaryHand = !self.secondaryHand
            switch self.secondaryHand {
            case true:
                self.face.secondaryHanded()
                
                break
            case false:
                self.face.primaryHanded()
                let twentyFivePercentFasterTempo = floor(self.desiredTempo*1.25)
                let twentyFivePercentSlowerAndIncrementallySlower = fmax(self.desiredTempo*(1.0/1.25) - 1, 40.0)
                self.fastPractice = !self.fastPractice
                switch self.fastPractice {
                case true:
                    self.desiredTempo = twentyFivePercentFasterTempo
                    break
                case false:
                    self.desiredTempo = twentyFivePercentSlowerAndIncrementallySlower
                    break
                }
                break
            }
            self.playPlayer()
            self.achieveDesiredTempo()
        }
    }
    
    func getFormattedTime(FromTime timeDuration:Int) -> String {
        
        let minutes = Int(timeDuration) / 60 % 60
        let seconds = Int(timeDuration) % 60
        let strDuration = String(format:"%02d:%02d", minutes, seconds)
        return strDuration
    }
    
    
    @objc func updateRemainingTime(_ timer:Timer){
        self.face.timeLeft.text = self.getFormattedTime(FromTime: remainingSecondsAtDesiredTempo)
        remainingSecondsAtDesiredTempo -= 1
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if player == object as? AVPlayer && keyPath == "status" {
            if player.status == .readyToPlay {
                
            }
        }
    }
    
    var timeRemainingTimer : Timer!
    
    func resetTimer(){
        self.timeRemainingTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(self.updateRemainingTime(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timeRemainingTimer, forMode: RunLoop.Mode.common)
    }
    
    @objc func faceDidAppear(_ notification:Notification){
        NotificationCenter.default.removeObserver(self, name: Face.didAppearNotification, object: nil)
        if let viewController = notification.object as? Face {
            self.face = viewController
            viewController.delegate = self
            
            switch playerState {
            default:
                
                face.tempoLabel.text = "\(desiredTempo)"
                let qBotWithBattlesURL = Bundle.main.url(forResource: "QBotAllTechniques", withExtension: "mp4")!
                let asset = AVAsset(url: qBotWithBattlesURL)
                
                let playerItem = AVPlayerItem(asset: asset)
                playerItem.audioTimePitchAlgorithm = .varispeed
                self.warpTimeForPlayerItem(self.desiredTempo)
                self.player = AVPlayer(playerItem: playerItem)
                self.player.actionAtItemEnd = .pause
        
                
                face.setLayerPlayer(player)
                switch self.secondaryHand {
                case true:
                    face.secondaryHanded()
                    break
                case false:
                    face.primaryHanded()
                    break
                }
                NotificationCenter.default.addObserver(self, selector: #selector(resetQBot), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                


                break
            }
            
        }
    }
    
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificationCenter.default.addObserver(self, selector: #selector(faceDidAppear(_:)), name: Face.didAppearNotification, object: nil)
        configureAudioSession()
        return true
    }

    var playbackInterrupted = false
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        let nowPlayingInfo = [MPMediaItemPropertyTitle:"Q-Bot"]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        pausePlayer()
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        configureAudioSession()
        /*q
        if playbackInterrupted {
            queuePlayer.play()
            achieveDesiredTempo()
            playbackInterrupted = false
        }
        */
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //face.secondTimer.start()
        //globalPlay()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       
    }
    

    
    func configureAudioSession(){
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: [.allowBluetoothA2DP, .allowAirPlay, .mixWithOthers,.defaultToSpeaker])
            } else {
                // Fallback on earlier versions
            }
            try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        }
        catch{
            //NSLog("catch configure audio session")
        }
    }

}

