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
    

    
    
    var speechSynthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    
    var face : Face!


    var videos : [String:[ThudRumbleVideoClip]] = [Key.Skratches.rawValue:[],
                                                   Key.Battles.rawValue:[]]
    var queuePlayer : AVQueuePlayer!
    var window: UIWindow?
    
    var skratchNames = [SkratchName.baby.rawValue,SkratchName.cutting.rawValue,SkratchName.reverseCutting.rawValue,SkratchName.marches.rawValue,SkratchName.drags.rawValue,SkratchName.chirps.rawValue,SkratchName.tears.rawValue,SkratchName.tips.rawValue,SkratchName.longShortTipTears.rawValue, SkratchName.fades.rawValue, SkratchName.transformer.rawValue,SkratchName.dicing.rawValue,SkratchName.oneClickFlare.rawValue, SkratchName.twoClickFlare.rawValue,SkratchName.flare.rawValue, SkratchName.crescentFlare.rawValue,SkratchName.chirpFlare.rawValue,SkratchName.cloverTears.rawValue, SkratchName.lazers.rawValue,SkratchName.phazers.rawValue, SkratchName.crabsCrepes.rawValue, SkratchName.scribbles.rawValue, SkratchName.zigZags.rawValue, SkratchName.swipes.rawValue, SkratchName.waves.rawValue, SkratchName.needleDropping.rawValue]
    
    var skratchBPMS : [Float] = [79.0,79.0,79.0,79.0,98.0,98.0,98.0,105.0,105.0,92.0,85.0,85.0,85.0,85.0,85.0,92.0,105.0,92.0,92.0,92.0,92.0,92.0,105.0,105.0,105.0,105.0]
    
    var battleNames = ["Deck Demon", "DJ Spy-D and The Spawnster", "Punt Rawk", "Bang", "Vlad Dufmeister", "Lambchop"]

    
    var sections = [Key.Skratches.rawValue,Key.Battles.rawValue]
    
    var playerItems : [AVPlayerItem] = []
    
    var infinitePeriodicTimer : Repeater!
    
    var desiredTempo : Float = 79.0
    
    fileprivate let babyTimes = [CMTime(value: 34961, timescale: 1000),CMTime(value: 41090, timescale: 1000),CMTime(value: 47099, timescale: 1000),CMTime(value: 53090, timescale: 1000)]
    
    fileprivate let cuttingTimes = [CMTime(value: 34961, timescale: 1000),CMTime(value: 41008, timescale: 1000),CMTime(value: 47046, timescale: 1000),CMTime(value: 53103, timescale: 1000)]
    
    fileprivate let reverseCuttingTimes = [CMTime(value: 23424, timescale: 1000),CMTime(value: 29509, timescale: 1000),CMTime(value: 35492, timescale: 1000),CMTime(value: 41616, timescale: 1000)]
    
    fileprivate let marchesTimes = [CMTime(value: 46952, timescale: 1000),CMTime(value: 52983, timescale: 1000),CMTime(value: 59032, timescale: 1000),CMTime(value: 65854, timescale: 1000)]
    
    fileprivate let dragsTimes = [CMTime(value: 15458, timescale: 1000),CMTime(value: 25246, timescale: 1000),CMTime(value: 35041, timescale: 1000),CMTime(value: 44841, timescale: 1000)]
    
    fileprivate let chirpsTimes = [CMTime(value: 64081, timescale: 1000),CMTime(value: 68963, timescale: 1000),CMTime(value: 73887, timescale: 1000),CMTime(value: 78775, timescale: 1000)]
    
    fileprivate let tearsTimes = [CMTime(value: 46952, timescale: 1000),CMTime(value: 52746, timescale: 1000),CMTime(value: 62557, timescale: 1000),CMTime(value: 72326, timescale: 1000)]
    
    fileprivate let tipsTimes = [CMTime(value: 27478, timescale: 1000),CMTime(value: 32058, timescale: 1000),CMTime(value: 36620, timescale: 1000),CMTime(value: 41184, timescale: 1000)]
    
    fileprivate let longShortTipTearsTimes = [CMTime(value: 49569, timescale: 1000),CMTime(value: 58712, timescale: 1000),CMTime(value: 67742, timescale: 1000),CMTime(value: 76987, timescale: 1000)]
    
    fileprivate let fadesTimes = [CMTime(value: 31414, timescale: 1000),CMTime(value: 41845, timescale: 1000),CMTime(value: 52257, timescale: 1000),CMTime(value: 62646, timescale: 1000)]
    
    fileprivate let transformerTimes = [CMTime(value: 50968, timescale: 1000),CMTime(value: 62268, timescale: 1000),CMTime(value: 73544, timescale: 1000),CMTime(value: 84826, timescale: 1000)]
    
    fileprivate let dicingTimes = [CMTime(value: 33453, timescale: 1000),CMTime(value: 44733, timescale: 1000),CMTime(value: 56045, timescale: 1000),CMTime(value: 67316, timescale: 1000)]
    
    fileprivate lazy var times = [babyTimes,cuttingTimes,reverseCuttingTimes,marchesTimes,dragsTimes,chirpsTimes,tearsTimes,tipsTimes,longShortTipTearsTimes,fadesTimes,transformerTimes,dicingTimes]
    
    fileprivate let aMilli = CMTime(value: 1, timescale: 1000)
    
    var skratchIndex = 0
    
    
    
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
    
    var randomItem : AVPlayerItem!
    var currentPhrase = 1
    var desiredPhrase = 16
    
    func chooseRandomItem(){
        let nextIndex = Int(arc4random_uniform(UInt32(self.playerItems.count)))
        let itemTimes = self.times[nextIndex]
        self.randomItem = self.playerItems[nextIndex]
        if self.skratchIndex != nextIndex {
            randomItem.seek(to: itemTimes[Int(arc4random_uniform(4))], toleranceBefore: self.aMilli, toleranceAfter: self.aMilli, completionHandler: nil)
            self.skratchIndex = nextIndex
            
        }
    }
    
    fileprivate func loopQs(){
        loadVideoByName(SkratchName.baby.rawValue)
        loadVideoByName(SkratchName.cutting.rawValue)
        loadVideoByName(SkratchName.reverseCutting.rawValue)
        loadVideoByName(SkratchName.marches.rawValue)
        loadVideoByName(SkratchName.drags.rawValue)
        loadVideoByName(SkratchName.chirps.rawValue)
        loadVideoByName(SkratchName.tears.rawValue)
        loadVideoByName(SkratchName.tips.rawValue)
        loadVideoByName(SkratchName.longShortTipTears.rawValue)
        loadVideoByName(SkratchName.fades.rawValue)
        loadVideoByName(SkratchName.transformer.rawValue)
        loadVideoByName(SkratchName.dicing.rawValue)
        playerItems.first!.seek(to: CMTime(value: 34961, timescale: 1000), toleranceBefore: aMilli, toleranceAfter: aMilli)
        chooseRandomItem()
        
        //6036
        //3018
        //1509
        infinitePeriodicTimer = Repeater.every(Repeater.Interval.milliseconds(3018), { (timer) in
            
            //self.queuePlayer.pause()
            DispatchQueue.main.sync {
                if self.currentPhrase % self.desiredPhrase == 0 {
                    self.playPause()
                }
                else {
                    self.queuePlayer.replaceCurrentItem(with: self.randomItem)
                    self.achieveDesiredTempo()
                }
                self.chooseRandomItem()
                self.currentPhrase = (self.currentPhrase + 1) % self.desiredPhrase
            }
            
            
            
        })
        
        
    }
    
    func achieveDesiredTempo() {
        let currentItemOriginalTempo = self.skratchBPMS[self.skratchIndex]
        self.queuePlayer.rate = (self.desiredTempo/currentItemOriginalTempo)
        //NSLog("\(self.queuePlayer.rate),\((self.desiredTempo/currentItemOriginalTempo))")
        //NSLog("\(self.desiredTempo),\(currentItemOriginalTempo)")
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
                loopQs()
                
                
                self.queuePlayer.insert(playerItems.first!, after: nil)
                self.queuePlayer.play()
                achieveDesiredTempo()


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

    var playbackInterrupted = false
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        let nowPlayingInfo = [MPMediaItemPropertyTitle:"Q-Bot"]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        if queuePlayer.rate > 0.0 {
            playbackInterrupted = true
        }
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        configureAudioSession()
        if playbackInterrupted {
            queuePlayer.play()
            playbackInterrupted = false
        }
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

