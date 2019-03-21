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
    
    var lastVideoWatched : String {
        get {
            return UserDefaults.standard.string(forKey: Key.lastVideoWatched.rawValue) ?? SkratchName.baby.rawValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.lastVideoWatched.rawValue)
        }
    }
    
    
    var face : Face!


    var videos : [String:[ThudRumbleVideoClip]] = [Key.Skratches.rawValue:[],
                                                   Key.EquipmentSetup.rawValue:[],
                                                   Key.Battles.rawValue:[]]
    var player : AVPlayer?
    var queuePlayer : AVQueuePlayer?
    var playerItem : AVPlayerItem?
    var asset : AVAsset?
    var window: UIWindow?
    
    var skratchNames = [SkratchName.baby.rawValue,SkratchName.cutting.rawValue,SkratchName.reverseCutting.rawValue,SkratchName.marches.rawValue,SkratchName.drags.rawValue,SkratchName.chirps.rawValue,SkratchName.tears.rawValue,SkratchName.tips.rawValue,SkratchName.longShortTipTears.rawValue,SkratchName.transformer.rawValue,SkratchName.dicing.rawValue,SkratchName.oneClickFlare.rawValue,SkratchName.crescentFlare.rawValue,SkratchName.chirpFlare.rawValue,SkratchName.lazers.rawValue,SkratchName.phazers.rawValue,SkratchName.scribbles.rawValue,SkratchName.fades.rawValue,SkratchName.cloverTears.rawValue,SkratchName.needleDropping.rawValue,SkratchName.zigZags.rawValue,SkratchName.waves.rawValue,SkratchName.swipes.rawValue,SkratchName.flare.rawValue,SkratchName.twoClickFlare.rawValue,SkratchName.crabsCrepes.rawValue]
    
    var skratchBPMs : [String:Double] = [:]
    
    var battleNames = ["Deck Demon", "DJ Spy-D and The Spawnster", "Punt Rawk", "Bang", "Vlad Dufmeister", "Lambchop"]

    
    var sections = [Key.Skratches.rawValue,Key.Battles.rawValue]
    
    func currentNanoseconds()->Int{
        var info = mach_timebase_info()
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }
        let currentTime = mach_absolute_time()
        let nanos = currentTime * UInt64(info.numer) / UInt64(info.denom)
        return Int(nanos)
    }
    
    func loadAssetsFromBundleIntoTables(){
        
        // MARK: Where your assets from your bundle get put into your tables
        
        for skratchName in skratchNames {
            
            loadSkratchAssetForName(skratchName)
            
        }
        /*
        for equipmentSetupName in equipmentSetupNames {
            loadEquipmentSetupAssetForName(equipmentSetupName)
        }
        */
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let playerItem = object as? WVPlayerItem {
            switch playerItem.status {
            case .readyToPlay:
                if let name = playerItem.name {
                    NSLog("name ready: \(name)")
                    playerItems[SkratchName(rawValue:name)!] = playerItem
                }
                break
            default:
                break
            }
        }
        
    }

   
    func loadTrackForVideo(_ trackNumber:Int){
        if lastVideoWatched.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            if trackNumber > 0 && trackNumber < 4{
                let selectionGroup = asset!.mediaSelectionGroup(forMediaCharacteristic: .audible)!
                let selectedOption = selectionGroup.options[trackNumber-1]
                DispatchQueue.main.async {
                    
                   self.queuePlayer?.pause()
                    self.queuePlayer?.currentItem?.select(selectedOption, in: selectionGroup)
                    self.queuePlayer?.rate = self.playbackRate
                    self.queuePlayer?.play()
                }
            }
        }
    }
    
    var currentSkratchIndex = 0
    
    var playerItems : [SkratchName:AVPlayerItem] = [:]
    
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
               
                let playerItem = WVPlayerItem(asset: asset)
                
                //playerItem?.seek(to: loop.start)
                playerItem.name = name
                playerItem.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
                playerItem.audioTimePitchAlgorithm = .varispeed
                //playerItem.setValue(name, forKey: "ThudRumbleVideoClipName")
                playerItem.addObserver(self, forKeyPath: "status", options: [], context: nil)
                let selectionGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible)!
                let selectedOption = selectionGroup.options[1]
                playerItem.select(selectedOption, in: selectionGroup)
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

