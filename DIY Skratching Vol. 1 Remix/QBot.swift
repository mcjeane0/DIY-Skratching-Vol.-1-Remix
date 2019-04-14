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
    
    //var skratchNames = [SkratchName.baby.rawValue,SkratchName.cutting.rawValue,SkratchName.reverseCutting.rawValue,SkratchName.marches.rawValue,SkratchName.drags.rawValue,SkratchName.chirps.rawValue,SkratchName.tears.rawValue,SkratchName.tips.rawValue,SkratchName.longShortTipTears.rawValue, SkratchName.fades.rawValue, SkratchName.transformer.rawValue,SkratchName.dicing.rawValue,SkratchName.oneClickFlare.rawValue, SkratchName.twoClickFlare.rawValue,SkratchName.flare.rawValue, SkratchName.crescentFlare.rawValue,SkratchName.cloverTears.rawValue, SkratchName.chirpFlare.rawValue, SkratchName.lazers.rawValue,SkratchName.phazers.rawValue, SkratchName.crabsCrepes.rawValue, SkratchName.scribbles.rawValue, SkratchName.zigZags.rawValue, SkratchName.swipes.rawValue, SkratchName.waves.rawValue, SkratchName.needleDropping.rawValue]
    
   // var skratchBPMS : [Float] = [79.0,79.0,79.0,79.0,98.0,98.0,98.0,105.0,105.0,92.0,85.0,85.0,85.0,85.0,85.0,92.0,105.0,92.0,92.0,92.0,92.0,92.0,105.0,105.0,105.0,105.0]
    
    //var battleNames = ["Deck Demon", "DJ Spy-D and The Spawnster", "Punt Rawk", "Bang", "Vlad Dufmeister", "Lambchop"]

    
    //var sections = [Key.Skratches.rawValue,Key.Battles.rawValue]
    
    //var playerItems : [AVPlayerItem] = []
    

    var desiredTempo : Float {
        get {
            let existingFloat = UserDefaults.standard.float(forKey: "desiredTempo")
            return existingFloat <= 1.0 ? 79.0 : existingFloat
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "desiredTempo")
            face.tempoLabel.text = "\(newValue)"
        }
    }
    
    /*
    
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
    
    
    fileprivate let oneClickTimes = [CMTime(value: 65955, timescale: 1000),CMTime(value: 77251, timescale: 1000),CMTime(value: 88529, timescale: 1000),CMTime(value: 99829, timescale: 1000)]
    
    fileprivate let twoClickTimes = [CMTime(value: 44487, timescale: 1000),CMTime(value: 55762, timescale: 1000),CMTime(value: 67049, timescale: 1000),CMTime(value: 78359, timescale: 1000)]
    
    fileprivate let flareTimes = [CMTime(value: 98987, timescale: 1000),CMTime(value: 110292, timescale: 1000),CMTime(value: 121581, timescale: 1000),CMTime(value: 132859, timescale: 1000)]
    
    fileprivate let crescentFlareTimes = [CMTime(value: 37111, timescale: 1000),CMTime(value: 47525, timescale: 1000),CMTime(value: 57927, timescale: 1000),CMTime(value: 68352, timescale: 1000)]
    
    fileprivate let cloverTearsTimes = [CMTime(value: 44992, timescale: 1000),CMTime(value: 49551, timescale: 1000),CMTime(value: 54124, timescale: 1000),CMTime(value: 58643, timescale: 1000)]
    
    fileprivate let chirpFlareTimes = [CMTime(value: 31642, timescale: 1000),CMTime(value: 42062, timescale: 1000),CMTime(value: 52464, timescale: 1000),CMTime(value: 62868, timescale: 1000)]
    
    fileprivate let lazersTimes = [CMTime(value: 43966, timescale: 1000),CMTime(value: 49175, timescale: 1000),CMTime(value: 54441, timescale: 1000),CMTime(value: 59570, timescale: 1000)]
    
    fileprivate let phazersTimes = [CMTime(value: 23113, timescale: 1000),CMTime(value: 28315, timescale: 1000),CMTime(value: 33525, timescale: 1000),CMTime(value: 38743, timescale: 1000)]
    
    fileprivate let crabsTimes = [CMTime(value: 58572, timescale: 1000),CMTime(value: 69075, timescale: 1000),CMTime(value: 79394, timescale: 1000),CMTime(value: 89810, timescale: 1000)]
    
    fileprivate let scribblesTimes = [CMTime(value: 44093, timescale: 1000),CMTime(value: 54497, timescale: 1000),CMTime(value: 64896, timescale: 1000),CMTime(value: 75310, timescale: 1000)]
    
    fileprivate let zigZagsTimes = [CMTime(value: 32494, timescale: 1000),CMTime(value: 37055, timescale: 1000),CMTime(value: 41633, timescale: 1000),CMTime(value: 46142, timescale: 1000)]
    
    fileprivate let swipesTimes = [CMTime(value: 52603, timescale: 1000),CMTime(value: 57098, timescale: 1000),CMTime(value: 61760, timescale: 1000),CMTime(value: 66291, timescale: 1000)]
    
    fileprivate let wavesTimes = [CMTime(value: 22449, timescale: 1000),CMTime(value: 31583, timescale: 1000),CMTime(value: 40736, timescale: 1000),CMTime(value: 49882, timescale: 1000)]
    
    fileprivate let needleDroppingTimes = [CMTime(value: 54434, timescale: 1000),CMTime(value: 63591, timescale: 1000),CMTime(value: 72751, timescale: 1000),CMTime(value: 81883, timescale: 1000)]
    
    
    
    fileprivate lazy var times = [babyTimes,cuttingTimes,reverseCuttingTimes,marchesTimes,dragsTimes,chirpsTimes,tearsTimes,tipsTimes,longShortTipTearsTimes,fadesTimes,transformerTimes,dicingTimes,oneClickTimes,twoClickTimes,flareTimes, crescentFlareTimes,cloverTearsTimes,chirpFlareTimes,lazersTimes,phazersTimes,crabsTimes,scribblesTimes,zigZagsTimes,swipesTimes,wavesTimes,needleDroppingTimes]
    
    */
    
    let aMilli = CMTime(value: 1, timescale: 1000)
    
   // var skratchIndex = 0
    
    /*
    
    func loadAssetsFromBundleIntoTables(){
        
        for skratchName in skratchNames {
            
            loadSkratchAssetForName(skratchName)
            
        }
       
        for battleName in battleNames {
            
            loadBattleAssetForName(battleName)
            
        }
        
        
        
    }
    
    func loadBattleAssetForName(_ name:String){
        //NSLog("\(name)")
        
        let battleURL = Bundle.main.url(forResource: name, withExtension:"m4v")!
        
        let battleVideo = ThudRumbleVideoClip(name: name, loop: nil, angles: [], tracks: [], url: battleURL)
        
        videos[Key.Battles.rawValue]?.append(battleVideo)
        
    }
    
    
    func loadSkratchAssetForName(_ string:String){
        //NSLog("\(string)")
        let angle1 = "\(string)"
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
    */
    
    var randomItem : AVPlayerItem!
    var currentPhrase = 1
    var desiredPhrase = 8
    
    var points = 0
    
    /*
    func chooseRandomItem(){
        let nextIndex = Int(arc4random_uniform(UInt32(self.difficultyIndex.rawValue < 25 ? self.difficultyIndex.rawValue : 25 % 26)))
        //NSLog("nextIndex:\(nextIndex), \(self.playerItems.count)")
        let itemTimes = self.times[nextIndex]
        self.randomItem = self.playerItems[nextIndex]
        randomItem.seek(to: itemTimes[Int(arc4random_uniform(4))], toleranceBefore: self.aMilli, toleranceAfter: self.aMilli, completionHandler: nil)
        self.skratchIndex = nextIndex
    }
    */
    
    var difficultyIndex : Difficulty = Difficulty.deckDemon
    
    
    enum Difficulty : Int {
        case deckDemon = 3
        case spyD = 6
        case puntRawk = 16
        case bang = 21
        case vlad = 25
        case lambchop = 26
        case q = 27
        
        static var order : [Int] = [deckDemon.rawValue,spyD.rawValue,puntRawk.rawValue,bang.rawValue,vlad.rawValue,lambchop.rawValue,q.rawValue]
        
        static postfix func ++(_ difficulty:inout Difficulty){
            let index = Difficulty.order.firstIndex(of: difficulty.rawValue)! + 1
            difficulty = Difficulty(rawValue:Difficulty.order[(index > Difficulty.order.count - 1 ? 0 : index)])!
        }
        
    }
    
    
    let seventyNineInterval = Int64((60.0/79.0*1000.0))

   
    
    func achieveDesiredTempo() {
        if self.player.rate > 0 {
            //let currentItemOriginalTempo = self.skratchBPMS[self.skratchIndex]
            self.player.rate = (self.desiredTempo/79.0)

        }
        //NSLog("\(self.queuePlayer.rate),\((self.desiredTempo/currentItemOriginalTempo))")
        //NSLog("\(self.desiredTempo),\(currentItemOriginalTempo)")
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
    
    @objc func resetQBot(_ notification:Notification){
        DispatchQueue.main.sync {
             self.player.currentItem!.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
            secondaryHand = !secondaryHand
            //let incrementallySlowerTempo = fmax(self.desiredTempo - 1.0,40.0)
            switch secondaryHand {
            case true:
                face.secondaryHanded()
                break
            case false:
                face.primaryHanded()
                let twentyFivePercentFasterTempo = floor(self.desiredTempo*1.25)
                let twentyFivePercentSlowerAndIncrementallySlower = fmax(self.desiredTempo*(1.0/1.25) - 1, 40.0)
                fastPractice = !fastPractice
                switch fastPractice {
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
    
    
    func updateRemainingTime(){
        guard self.player.status == .readyToPlay else {
            return
        }
        self.face.timeLeft.text = self.getFormattedTime(FromTime: Int(CMTimeGetSeconds(self.player.currentItem!.duration)) - Int(CMTimeGetSeconds(self.player.currentTime())))
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if player == object as? AVPlayer && keyPath == "status" {
            if player.status == .readyToPlay {
                
            }
        }
    }
    
    @objc func faceDidAppear(_ notification:Notification){
        NotificationCenter.default.removeObserver(self, name: Face.didAppearNotification, object: nil)
        if let viewController = notification.object as? Face {
            self.face = viewController
            viewController.delegate = self
            
            switch playerState {
            default:
                
                face.tempoLabel.text = "\(desiredTempo)"
                let qBotWithBattlesURL = Bundle.main.url(forResource: "QBotAllTechniques", withExtension: "m4v")!
                let asset = AVAsset(url: qBotWithBattlesURL)
                
                let playerItem = AVPlayerItem(asset: asset)
                playerItem.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
                playerItem.audioTimePitchAlgorithm = .varispeed
                
                self.player = AVPlayer(playerItem: playerItem)
                self.player.actionAtItemEnd = .pause
                self.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1000, timescale: 1000), queue: DispatchQueue.main) { (time) in
                    self.updateRemainingTime()
                }
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
        self.player.seek(to: CMTime.zero)
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

