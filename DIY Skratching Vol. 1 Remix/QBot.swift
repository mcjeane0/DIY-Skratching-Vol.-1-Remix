//
//  QBot.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 9/14/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit
import CoreData
import AVKit
import MediaPlayer
import Speech
import Repeat

@UIApplicationMain

class QBot: UIResponder, UIApplicationDelegate {

    var play : Play {
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
    
    var playbackRate : Float {
        get {
            let oldValue = UserDefaults.standard.float(forKey: Key.rate.rawValue)
            return oldValue > 0.0 ? oldValue : 1.0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.rate.rawValue)
            DispatchQueue.main.async {
                self.queuePlayer?.rate = newValue
            }
        }
    }
    

    
    
    var speechSynthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    
    var face : Face!


    var videos : [String:[ThudRumbleVideoClip]] = [Key.Skratches.rawValue:[],
                                                   Key.Battles.rawValue:[]]
    var queuePlayer : AVQueuePlayer!
    var window: UIWindow?
    
    var skratchNames = [SkratchName.baby.rawValue,SkratchName.cutting.rawValue,SkratchName.reverseCutting.rawValue,SkratchName.marches.rawValue,SkratchName.drags.rawValue,SkratchName.chirps.rawValue,SkratchName.tears.rawValue,SkratchName.tips.rawValue,SkratchName.longShortTipTears.rawValue,SkratchName.transformer.rawValue,SkratchName.dicing.rawValue,SkratchName.oneClickFlare.rawValue,SkratchName.crescentFlare.rawValue,SkratchName.chirpFlare.rawValue,SkratchName.lazers.rawValue,SkratchName.phazers.rawValue,SkratchName.scribbles.rawValue,SkratchName.fades.rawValue,SkratchName.cloverTears.rawValue,SkratchName.needleDropping.rawValue,SkratchName.zigZags.rawValue,SkratchName.waves.rawValue,SkratchName.swipes.rawValue,SkratchName.flare.rawValue,SkratchName.twoClickFlare.rawValue,SkratchName.crabsCrepes.rawValue]
    
    var battleNames = ["Deck Demon", "DJ Spy-D and The Spawnster", "Punt Rawk", "Bang", "Vlad Dufmeister", "Lambchop"]

    
    var sections = [Key.Skratches.rawValue,Key.Battles.rawValue]
    
    var playerItems : [AVPlayerItem] = []
    
    var infinitePeriodicTimer : Repeater!
    
    func currentNanoseconds()->Int{
        var info = mach_timebase_info()
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }
        let currentTime = mach_absolute_time()
        let nanos = currentTime * UInt64(info.numer) / UInt64(info.denom)
        return Int(nanos)
    }
    
    func loadAssetsFromBundleIntoTables(){
        
        for skratchName in skratchNames {
            
            loadSkratchAssetForName(skratchName)
            
        }
       
        for battleName in battleNames {
            
            loadBattleAssetForName(battleName)
            
        }
        
        
        
    }
    
    func loadBattleAssetForName(_ name:String){
        NSLog("\(name)")
        
        let battleURL = Bundle.main.url(forResource: name, withExtension:"m4v")!
        
        let battleVideo = ThudRumbleVideoClip(name: name, loop: nil, angles: [], tracks: [], url: battleURL)
        
        videos[Key.Battles.rawValue]?.append(battleVideo)
        
    }
    
    
    func loadSkratchAssetForName(_ string:String){
        NSLog("\(string)")
        let angle1 = "\(string) Angle 1"
        let angle1URL = Bundle.main.url(forResource: angle1, withExtension: "m4v")!
        let angle1Video = ThudRumbleVideoClip(name: angle1, loop: nil, angles: [], tracks: [], url: angle1URL)
        videos[Key.Skratches.rawValue]?.append(angle1Video)
        
    }
    
    
    fileprivate func cycleAllSkratches() {
        for name in skratchNames {
            loadVideoByName(name)
        }
        infinitePeriodicTimer = Repeater.every(Repeater.Interval.seconds(1.0), { (timer) in
            self.queuePlayer.advanceToNextItem()
        })
    }
    
    fileprivate var babyTimes = [CMTime(value: 34961, timescale: 1000),CMTime(value: 41002, timescale: 1000),CMTime(value: 47024, timescale: 1000),CMTime(value: 53009, timescale: 1000)]
    
    fileprivate func loopBabyQs(){
        loadVideoByName(skratchNames.first!)
        playerItems.first!.seek(to: CMTime(value: 34961, timescale: 1000))
        
        infinitePeriodicTimer = Repeater.every(Repeater.Interval.milliseconds(3018), { (timer) in
            
            self.playerItems.first!.seek(to: self.babyTimes[Int(arc4random_uniform(3))])
        })
        
    }
    
    @objc func faceDidAppear(_ notification:Notification){
        if let viewController = notification.object as? Face {
            self.face = viewController
            viewController.delegate = self
            
            switch play {
            default:
                
                queuePlayer = AVQueuePlayer(playerItem: nil)
                face.setLayerPlayer(queuePlayer)
                
                
                //cycleAllSkratches()
                loopBabyQ1()
                
                for item in playerItems {
                    self.queuePlayer.insert(item, after: nil)
                }
                self.queuePlayer.play()

                break
            }
            
        }
    }
    
    func loadVideoByName(_ string:String){
        let arrayOfArrayOfVideos : [[ThudRumbleVideoClip]] = videos.map { (arg: (key: String, value: [ThudRumbleVideoClip])) -> [ThudRumbleVideoClip] in

            let (_, value) = arg
            return value
        }
        let arrayOfVideos = arrayOfArrayOfVideos.flatMap{$0}
        var name : String = string
        NSLog("name:\(name)")
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            name = "\(string) Angle 1"
            let matchingVideo = arrayOfVideos.filter { (video) -> Bool in
                if video.name == name {
                    return true
                }
                else {
                    return false
                }
                }.first
            if matchingVideo != nil {
                let asset = AVAsset(url: matchingVideo!.url)
               
                let playerItem = AVPlayerItem(asset: asset)
                playerItem.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
                playerItem.audioTimePitchAlgorithm = .varispeed
                let selectionGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible)!
                let selectedOption = selectionGroup.options[1]
                playerItem.select(selectedOption, in: selectionGroup)
                playerItems.append(playerItem)
            }
            else {
            }
        }
    }
   
//
//    //
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificationCenter.default.addObserver(self, selector: #selector(faceDidAppear(_:)), name: Face.didAppearNotification, object: nil)
        loadAssetsFromBundleIntoTables()
        configureAudioSession()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        let nowPlayingInfo = [MPMediaItemPropertyTitle:"Q-Bot"]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        configureAudioSession()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
            NSLog("catch configure audio session")
        }
    }

}

