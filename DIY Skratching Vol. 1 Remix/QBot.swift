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
import Speech

class ThudRumbleVideoClip {

    var name : String
    var loop : CMTimeRange?
    var angles : [ThudRumbleVideoClip]
    var tracks : [String]
    var url : URL
    var rate : Float {
        get {
            let value = UserDefaults.standard.float(forKey: "\(name)Rate")
            if value == 0.0 {
                UserDefaults.standard.set(1.0, forKey:name)
                return 1.0
            }
            return value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(name)Rate")
        }
    }
    var pitchAlgorithm : AVAudioTimePitchAlgorithm {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: Key.pitchAlgorithm.rawValue){
                return AVAudioTimePitchAlgorithm(rawValue: rawValue)
            }
            return AVAudioTimePitchAlgorithm.varispeed
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Key.pitchAlgorithm.rawValue)
        }
    }

    init(name:String,loop:CMTimeRange?,angles:[ThudRumbleVideoClip],tracks:[String],url:URL){
        self.name = name
        self.loop = loop
        self.angles = angles
        self.tracks = tracks
        self.url = url
        
    }

}

extension QBot : FaceDelegate {
    
    func handleTwoFingerTap() {
        if let rate = queuePlayer?.rate, rate > 1/64 {
            queuePlayer?.pause()
        }
        else {
            queuePlayer?.play()
        }
    }
    
    func handleLongPress() {
        
    }
    
    func handleTap() {
        
    }
    
    func handleSwipeUp() {
        let maxSectionIndex = sections.count - 1
        let incrementedSectionIndex = self.faceIndexPath.section + 1
        let nextPossibleSectionIndex = incrementedSectionIndex > maxSectionIndex ? 0 : incrementedSectionIndex
        let nextSection = sections[nextPossibleSectionIndex]
        switch nextSection {
        case Key.Skratches.rawValue:
            let rowIndex = skratchNames.firstIndex(of: lastSkratchVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        case Key.Battles.rawValue:
            let rowIndex = battleNames.firstIndex(of: lastBattleVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        case Key.EquipmentSetup.rawValue:
            let rowIndex = equipmentSetupNames.firstIndex(of: lastEquipmentSetupVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        default:
            break
        }
        
        loadVideoAtFaceIndexPath()
    }
    
    func handleSwipeDown() {
        let maxSectionIndex = sections.count - 1
        let decrementedSectionIndex = self.faceIndexPath.section - 1
        let nextPossibleSectionIndex = decrementedSectionIndex < 0 ? maxSectionIndex : decrementedSectionIndex
        let nextSection = sections[nextPossibleSectionIndex]
        switch nextSection {
        case Key.Skratches.rawValue:
            let rowIndex = skratchNames.firstIndex(of: lastSkratchVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        case Key.Battles.rawValue:
            let rowIndex = battleNames.firstIndex(of: lastBattleVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        case Key.EquipmentSetup.rawValue:
            let rowIndex = equipmentSetupNames.firstIndex(of: lastEquipmentSetupVideo)!
            faceIndexPath = IndexPath(row: rowIndex, section: nextPossibleSectionIndex)
            break
        default:
            break
        }
        
        loadVideoAtFaceIndexPath()
    }
    
    func handleSwipeLeft() {
        let currentSection = sections[self.faceIndexPath.section]
        let maxItemCount = videos[currentSection]!.count-1
        let incrementedIndex = self.faceIndexPath.row + 1
        let nextPossibleRowIndex = incrementedIndex > maxItemCount ? 0 : incrementedIndex
        
        faceIndexPath = IndexPath(row: nextPossibleRowIndex, section: self.faceIndexPath.section)
        loadVideoAtFaceIndexPath()
        
    }
    
    func handleSwipeRight() {
        let currentSection = sections[self.faceIndexPath.section]
        let maxItemCount = videos[currentSection]!.count - 1
        let decrementedIndex = self.faceIndexPath.row - 1
        let nextPossibleRowIndex = decrementedIndex < 0 ? maxItemCount : decrementedIndex
        
        faceIndexPath = IndexPath(row: nextPossibleRowIndex, section: self.faceIndexPath.section)
        loadVideoAtFaceIndexPath()
        
    }

}

@UIApplicationMain

class QBot: UIResponder, UIApplicationDelegate {
    
    
    
    var speechRecognitionRecorder : AVAudioRecorder?
    var speechRecognizer : SFSpeechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
    
    
    var speechSynthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var lastVideoWatched : String {
        get {
            return UserDefaults.standard.string(forKey: Key.lastVideoWatched.rawValue) ?? SkratchName.baby.rawValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.lastVideoWatched.rawValue)
        }
    }
    
    var lastEquipmentSetupVideo : String {
        get {
            return UserDefaults.standard.string(forKey: Key.lastEquipmentSetupVideoWatched.rawValue) ?? "Cueing"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.lastEquipmentSetupVideoWatched.rawValue)
        }
    }
    
    var lastBattleVideo : String {
        get {
            return UserDefaults.standard.string(forKey: Key.lastBattleVideoWatched.rawValue) ?? "Battle Devil"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.lastBattleVideoWatched.rawValue)
        }
    }
    
    var lastSkratchVideo : String {
        get {
            return UserDefaults.standard.string(forKey: Key.lastSkratchVideoWatched.rawValue) ?? SkratchName.baby.rawValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.lastSkratchVideoWatched.rawValue)
        }
    }
    
    var faceIndexPath : IndexPath {
        get {
            return IndexPath(row: UserDefaults.standard.integer(forKey: Key.rowIndex.rawValue), section: UserDefaults.standard.integer(forKey: Key.sectionIndex.rawValue))
        }
        set{
            UserDefaults.standard.set(newValue.row, forKey: Key.rowIndex.rawValue)
            UserDefaults.standard.set(newValue.section, forKey: Key.sectionIndex.rawValue)
        }
    }
    
    var selectedTrack : Int = 1
    var selectedAngle : Int = 2

    var viewController : Face!


    var videos : [String:[ThudRumbleVideoClip]] = [Key.Skratches.rawValue:[],
                                                   Key.EquipmentSetup.rawValue:[],
                                                   Key.Battles.rawValue:[]]
    var playerLooper : AVPlayerLooper?
    var queuePlayer : AVQueuePlayer?
    var playerItem : AVPlayerItem?
    var asset : AVAsset?
    var window: UIWindow?

    var skratchLoops : [String:CMTimeRange] = [
                                            SkratchName.baby.rawValue:CMTimeRange(start: CMTime(seconds: 59, preferredTimescale: 1), end: CMTime(seconds: 83, preferredTimescale: 1)),
                                               SkratchName.flare.rawValue:CMTimeRange(start: CMTime(seconds: 133, preferredTimescale: 1), end: CMTime(seconds: 166, preferredTimescale: 1)),
                                               SkratchName.crabsCrepes.rawValue:CMTimeRange(start: CMTime(seconds: 100, preferredTimescale: 1), end: CMTime(seconds: 141, preferredTimescale: 1)),
                                               SkratchName.swipes.rawValue:CMTimeRange(start: CMTime(seconds: 61, preferredTimescale: 1), end: CMTime(seconds: 80, preferredTimescale: 1)),
                                               SkratchName.waves.rawValue:CMTimeRange(start: CMTime(seconds: 58, preferredTimescale: 1), end: CMTime(seconds: 95, preferredTimescale: 1)),
                                               SkratchName.zigZags.rawValue:CMTimeRange(start: CMTime(seconds: 50, preferredTimescale: 1), end: CMTime(seconds: 69, preferredTimescale: 1)),
                                               SkratchName.cloverTears.rawValue:CMTimeRange(start: CMTime(seconds: 63, preferredTimescale: 1), end: CMTime(seconds: 81, preferredTimescale: 1)),
                                               SkratchName.needleDropping.rawValue:CMTimeRange(start: CMTime(seconds: 81, preferredTimescale: 1), end: CMTime(seconds: 109, preferredTimescale: 1)),
                                               SkratchName.scribbles.rawValue:CMTimeRange(start: CMTime(seconds: 90, preferredTimescale: 1), end: CMTime(seconds: 137, preferredTimescale: 1)),
                                               SkratchName.phazers.rawValue:CMTimeRange(start: CMTime(seconds: 44, preferredTimescale: 1), end: CMTime(seconds: 64, preferredTimescale: 1)),
                                               SkratchName.lazers.rawValue:CMTimeRange(start: CMTime(seconds: 64, preferredTimescale: 1), end: CMTime(seconds: 85, preferredTimescale: 1)),
                                               SkratchName.chirpFlare.rawValue:CMTimeRange(start: CMTime(seconds: 73, preferredTimescale: 1), end: CMTime(seconds: 114, preferredTimescale: 1)),
                                               SkratchName.chirps.rawValue:CMTimeRange(start: CMTime(seconds: 82, preferredTimescale: 1), end: CMTime(seconds: 103, preferredTimescale: 1)),
                                               SkratchName.drags.rawValue:CMTimeRange(start: CMTime(seconds: 54, preferredTimescale: 1), end: CMTime(seconds: 94, preferredTimescale: 1)),
                                               SkratchName.transformer.rawValue:CMTimeRange(start: CMTime(seconds: 95, preferredTimescale: 1), end: CMTime(seconds: 141, preferredTimescale: 1)),
                                               SkratchName.tips.rawValue :CMTimeRange(start: CMTime(seconds: 45, preferredTimescale: 1), end: CMTime(seconds: 64, preferredTimescale: 1)),
                                               SkratchName.tears.rawValue:CMTimeRange(start: CMTime(seconds: 82, preferredTimescale: 1), end: CMTime(seconds: 121, preferredTimescale: 1)),
                                               SkratchName.dicing.rawValue:CMTimeRange(start: CMTime(seconds: 78, preferredTimescale: 1), end: CMTime(seconds: 124, preferredTimescale: 1)),
                                               SkratchName.marches.rawValue:CMTimeRange(start: CMTime(seconds: 71, preferredTimescale: 1), end: CMTime(seconds: 95, preferredTimescale: 1)),
                                               SkratchName.reverseCutting.rawValue:CMTimeRange(start: CMTime(seconds: 47, preferredTimescale: 1), end: CMTime(seconds: 93, preferredTimescale: 1)),
                                               SkratchName.cutting.rawValue:CMTimeRange(start: CMTime(seconds: 59, preferredTimescale: 1), end: CMTime(seconds: 83, preferredTimescale: 1)),
                                               SkratchName.longShortTipTears.rawValue:CMTimeRange(start: CMTime(seconds: 85, preferredTimescale: 1), end: CMTime(seconds: 122, preferredTimescale: 1)),
                                               SkratchName.oneClickFlare.rawValue:CMTimeRange(start: CMTime(seconds: 111, preferredTimescale: 1), end: CMTime(seconds: 156, preferredTimescale: 1)),
                                               SkratchName.fades.rawValue:CMTimeRange(start: CMTime(seconds: 73, preferredTimescale: 1), end: CMTime(seconds: 114, preferredTimescale: 1)),
                                               SkratchName.twoClickFlare.rawValue:CMTimeRange(start: CMTime(seconds: 78, preferredTimescale: 1), end: CMTime(seconds: 112, preferredTimescale: 1)),
                                               SkratchName.crescentFlare.rawValue: CMTimeRange(start: CMTime(seconds: 78, preferredTimescale: 1), end: CMTime(seconds: 120, preferredTimescale: 1))]
    
    var skratchNames = [SkratchName.baby.rawValue,SkratchName.cutting.rawValue,SkratchName.reverseCutting.rawValue,SkratchName.marches.rawValue,SkratchName.drags.rawValue,SkratchName.chirps.rawValue,SkratchName.tears.rawValue,SkratchName.tips.rawValue,SkratchName.longShortTipTears.rawValue,SkratchName.transformer.rawValue,SkratchName.dicing.rawValue,SkratchName.oneClickFlare.rawValue,SkratchName.crescentFlare.rawValue,SkratchName.chirpFlare.rawValue,SkratchName.lazers.rawValue,SkratchName.phazers.rawValue,SkratchName.scribbles.rawValue,SkratchName.fades.rawValue,SkratchName.cloverTears.rawValue,SkratchName.needleDropping.rawValue,SkratchName.zigZags.rawValue,SkratchName.waves.rawValue,SkratchName.swipes.rawValue,SkratchName.flare.rawValue,SkratchName.twoClickFlare.rawValue,SkratchName.crabsCrepes.rawValue]
    
    var battleNames = ["Battle Devil", "Battle Football", "Battle Gasmask", "Battle Spiderman", "Battle Smiley", "Battle Bunny", "Q-Bert Freestyle"]
    
    var equipmentSetupNames = ["Counting Bars",  "Cueing", "Slipmats Part 1", "Slipmats Part 2", "Setting Up Headshells", "Plugging In Turntables", "Turntable Adjustments","Mixer Basics", "EQ Scratching", "Preventing Skipping", "More Ways To Prevent Skipping", "Getting better adhesion","Cleaning Needles", "Fader Caps Adjustment", "Tuner Control Spray", "On Off Switch Adjustment", "How to seal leaky pipes"]
    
    var sections = [Key.Skratches.rawValue,Key.Battles.rawValue,Key.EquipmentSetup.rawValue]
    
    func loadVideoAtFaceIndexPath(){
        
        let section = sections[faceIndexPath.section]
        NSLog("\(faceIndexPath)")
        switch section {
        case Key.Skratches.rawValue:
            lastSkratchVideo = skratchNames[faceIndexPath.row]
            lastVideoWatched = lastSkratchVideo
            break
        case Key.Battles.rawValue:
            lastBattleVideo = battleNames[faceIndexPath.row]
            lastVideoWatched = lastBattleVideo
            break
        case Key.EquipmentSetup.rawValue:
            lastEquipmentSetupVideo = equipmentSetupNames[faceIndexPath.row]
            lastVideoWatched = lastEquipmentSetupVideo
            break
        default:
            break
        }
        
        loadVideoByName(lastVideoWatched,looped: false) { (completed) in
            queuePlayer?.play()
            queuePlayer?.rate = 0.0
            queuePlayer?.rate = 1.0

        }
        
    }
    
    func loadAssetsFromBundleIntoTables(){
        
        // MARK: Where your assets from your bundle get put into your tables
        
        for skratchName in skratchNames {
            
            loadSkratchAssetForName(skratchName,loop:skratchLoops[skratchName]!)
            
        }
        
        for equipmentSetupName in equipmentSetupNames {
            loadEquipmentSetupAssetForName(equipmentSetupName)
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
    
    func loadEquipmentSetupAssetForName(_ name:String){
        NSLog("\(name)")

        let equipmentSetupURL = Bundle.main.url(forResource: name, withExtension: "m4v")!
        
        let equipmentSetupVideo = ThudRumbleVideoClip(name: name, loop: nil, angles: [], tracks: [], url: equipmentSetupURL)
        
        videos[Key.EquipmentSetup.rawValue]?.append(equipmentSetupVideo)
        
    }
    
    
    func loadSkratchAssetForName(_ string:String,loop:CMTimeRange){
        NSLog("\(string)")
        let angle1 = "\(string) Angle 1"
        let angle2 = "\(string) Angle 2"
        let angle3 = "\(string) Angle 3"
        let angle4 = "\(string) Angle 4"
        let angle1URL = Bundle.main.url(forResource: angle1, withExtension: "m4v")!
        let angle2URL = Bundle.main.url(forResource: angle2, withExtension: "m4v")!
        let angle3URL = Bundle.main.url(forResource: angle3, withExtension: "m4v")!
        let angle4URL = Bundle.main.url(forResource: angle4, withExtension: "m4v")!

        let angle2Video = ThudRumbleVideoClip(name: angle2, loop: loop, angles: [], tracks: [], url: angle2URL)
        let angle3Video = ThudRumbleVideoClip(name: angle3, loop: loop, angles: [], tracks: [], url: angle3URL)
        let angle4Video = ThudRumbleVideoClip(name: angle4, loop: loop, angles: [], tracks: [], url: angle4URL)
        let angle1Video = ThudRumbleVideoClip(name: angle1, loop: loop, angles: [angle2Video,angle3Video,angle4Video], tracks: [], url: angle1URL)
        angle2Video.angles = [angle3Video,angle4Video,angle1Video]
        angle3Video.angles = [angle4Video,angle1Video,angle2Video]
        angle4Video.angles = [angle1Video,angle2Video,angle3Video]
        
        
        
        
        videos[Key.Skratches.rawValue]?.append(angle1Video)
        
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let playerItem = object as? AVPlayerItem {
            switch playerItem.status {
            case .readyToPlay:
                playerItem.audioTimePitchAlgorithm = .varispeed
                playerItem.seek(to: CMTime.zero, completionHandler: nil)
                break
            default:
                break
            }
        }
    }

    @objc func playbackEnded(says notification:Notification) {
        if let loopCount = playerLooper?.loopCount {
            NSLog("loopCount: \(loopCount)")
        }
        NotificationCenter.default.removeObserver(self, name: nil, object: notification.object)
        loadVideoByName(lastVideoWatched,looped:true) { (loaded) in
            queuePlayer?.play()
        }
    }

    func loadTrackForVideo(_ trackNumber:Int){
        if lastVideoWatched.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            if trackNumber > 0 && trackNumber < 4{
                let selectionGroup = asset!.mediaSelectionGroup(forMediaCharacteristic: .audible)!
                let selectedOption = selectionGroup.options[trackNumber-1]
                queuePlayer?.currentItem?.select(selectedOption, in: selectionGroup)
            }
        }
    }
    
    func loadVideoByName(_ string:String,looped:Bool,completion:(_ completed:Bool)->()){
        let arrayOfArrayOfVideos : [[ThudRumbleVideoClip]] = videos.map { (arg: (key: String, value: [ThudRumbleVideoClip])) -> [ThudRumbleVideoClip] in

            let (_, value) = arg
            return value
        }
        let arrayOfVideos = arrayOfArrayOfVideos.flatMap{$0}
        var name : String = string
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            name = "\(string) Angle 1"

        }
        let matchingVideo = arrayOfVideos.filter { (video) -> Bool in
            if video.name == name {
                return true
            }
            else {
                return false
            }
        }.first
        if matchingVideo != nil {
            let matchingAngleName = "\(string) Angle \(selectedAngle)"
            let matchingAngleVideo = matchingVideo!.angles.filter { (video) -> Bool in
                if video.name == matchingAngleName {
                    return true
                }
                return false
            }.first
            if matchingAngleVideo != nil {
                asset = AVAsset(url: matchingVideo!.url)
                let chapters = asset!.chapterMetadataGroups(bestMatchingPreferredLanguages: [])
                let audioTracks = asset!.tracks
                playerItem = AVPlayerItem(asset: asset!, automaticallyLoadedAssetKeys: nil)
                playerItem?.addObserver(self, forKeyPath: "status", options: [], context: nil)
                queuePlayer = AVQueuePlayer(playerItem: playerItem)
                
                
                playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem!, timeRange: chapters.last?.timeRange ?? CMTimeRange.invalid)
                
                if matchingVideo!.loop != nil {
                    playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem!, timeRange: matchingVideo!.loop!)
                }
                else {
                    playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem:playerItem!)
                }
                
                if !looped{
                    NotificationCenter.default.addObserver(self, selector: #selector(playbackEnded(says:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
                    
                    playerLooper?.disableLooping()
                }
                viewController.setLayerPlayerLooper(queuePlayer!)
                
                completion(true)
            }
        }
        else {
            completion(false)
        }
    }

    @objc func faceDidAppear(_ notification:Notification){
        if let viewController = notification.object as? Face {
            viewController.delegate = self
            self.viewController = viewController
            loadVideoAtFaceIndexPath()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificationCenter.default.addObserver(self, selector: #selector(faceDidAppear(_:)), name: Face.didAppearNotification, object: nil)
        loadAssetsFromBundleIntoTables()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DIY_Skratching_Vol__1_Remix")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

