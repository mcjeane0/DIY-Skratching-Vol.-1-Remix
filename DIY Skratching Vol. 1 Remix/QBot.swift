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


class ThudRumbleVideoClip {

    var name : String
    var loop : CMTimeRange?
    var angles : [String]
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

    init(name:String,loop:CMTimeRange?,angles:[String],tracks:[String],url:URL){
        self.name = name
        self.loop = loop
        self.angles = angles
        self.tracks = tracks
        self.url = url
        
    }

}

extension QBot : FaceDelegate {
    
    func handleTwoFingerTap() {
        
    }
    
    func handleLongPress() {
        
    }
    
    func handleTap() {
        
    }
    
    func handleSwipeUp() {
        let nextPossibleSectionIndex = (self.faceIndexPath.section + 1) % sections.count
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
        let nextPossibleSectionIndex = (self.faceIndexPath.section - 1) % sections.count
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
        let nextPossibleRowIndex = (self.faceIndexPath.row + 1) % videos[currentSection]!.count
        
        faceIndexPath = IndexPath(row: nextPossibleRowIndex, section: self.faceIndexPath.section)
        loadVideoAtFaceIndexPath()
        
    }
    
    func handleSwipeRight() {
        let currentSection = sections[self.faceIndexPath.section]
        let nextPossibleRowIndex = (self.faceIndexPath.row - 1) % videos[currentSection]!.count
        
        faceIndexPath = IndexPath(row: nextPossibleRowIndex, section: self.faceIndexPath.section)
        loadVideoAtFaceIndexPath()
        
    }

}

@UIApplicationMain

class QBot: UIResponder, UIApplicationDelegate {
    
    var lastVideoWatched : String {
        get {
            return UserDefaults.standard.string(forKey: Key.lastVideoWatched.rawValue) ?? "baby"
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
            return UserDefaults.standard.string(forKey: Key.lastSkratchVideoWatched.rawValue) ?? "baby"
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
    var selectedAngle : Int = 1

    var viewController : Face!


    var videos : [String:[ThudRumbleVideoClip]] = [Key.Skratches.rawValue:[],
                                                   Key.EquipmentSetup.rawValue:[],
                                                   Key.Battles.rawValue:[]]
    var playerLooper : AVPlayerLooper?
    var queuePlayer : AVQueuePlayer?
    var playerItem : AVPlayerItem?
    var window: UIWindow?

    var skratchLoops : [String:CMTimeRange] = ["Baby":CMTimeRange(start: CMTime(seconds: 59, preferredTimescale: 1), end: CMTime(seconds: 84, preferredTimescale: 1)),"Flare":CMTimeRange(start: CMTime(seconds: 133, preferredTimescale: 1), end: CMTime(seconds: 166, preferredTimescale: 1)),"Crabs (Crepes)":CMTimeRange(start: CMTime(seconds: 100, preferredTimescale: 1), end: CMTime(seconds: 141, preferredTimescale: 1)),"Swipes":CMTimeRange(start: CMTime(seconds: 61, preferredTimescale: 1), end: CMTime(seconds: 80, preferredTimescale: 1)),"Waves":CMTimeRange(start: CMTime(seconds: 58, preferredTimescale: 1), end: CMTime(seconds: 95, preferredTimescale: 1)),"Zig Zags":CMTimeRange(start: CMTime(seconds: 50, preferredTimescale: 1), end: CMTime(seconds: 69, preferredTimescale: 1)), "Clover Tears":CMTimeRange(start: CMTime(seconds: 63, preferredTimescale: 1), end: CMTime(seconds: 81, preferredTimescale: 1)), "Needle Dropping":CMTimeRange(start: CMTime(seconds: 81, preferredTimescale: 1), end: CMTime(seconds: 109, preferredTimescale: 1)), "Scribbles":CMTimeRange(start: CMTime(seconds: 90, preferredTimescale: 1), end: CMTime(seconds: 137, preferredTimescale: 1)), "Phazers":CMTimeRange(start: CMTime(seconds: 44, preferredTimescale: 1), end: CMTime(seconds: 64, preferredTimescale: 1)), "Lazers":CMTimeRange(start: CMTime(seconds: 64, preferredTimescale: 1), end: CMTime(seconds: 85, preferredTimescale: 1)), "Chirp Flare":CMTimeRange(start: CMTime(seconds: 73, preferredTimescale: 1), end: CMTime(seconds: 114, preferredTimescale: 1)), "Chirps":CMTimeRange(start: CMTime(seconds: 82, preferredTimescale: 1), end: CMTime(seconds: 103, preferredTimescale: 1)), "Drag":CMTimeRange(start: CMTime(seconds: 54, preferredTimescale: 1), end: CMTime(seconds: 94, preferredTimescale: 1)), "Transformer":CMTimeRange(start: CMTime(seconds: 96, preferredTimescale: 1), end: CMTime(seconds: 142, preferredTimescale: 1)), "Tip":CMTimeRange(start: CMTime(seconds: 45, preferredTimescale: 1), end: CMTime(seconds: 64, preferredTimescale: 1)), "Tears":CMTimeRange(start: CMTime(seconds: 82, preferredTimescale: 1), end: CMTime(seconds: 121, preferredTimescale: 1)), "Dicing":CMTimeRange(start: CMTime(seconds: 78, preferredTimescale: 1), end: CMTime(seconds: 124, preferredTimescale: 1)), "Marches":CMTimeRange(start: CMTime(seconds: 71, preferredTimescale: 1), end: CMTime(seconds: 95, preferredTimescale: 1)), "Reverse Cutting":CMTimeRange(start: CMTime(seconds: 47, preferredTimescale: 1), end: CMTime(seconds: 96, preferredTimescale: 1)), "Cutting":CMTimeRange(start: CMTime(seconds: 59, preferredTimescale: 1), end: CMTime(seconds: 84, preferredTimescale: 1)), "Long-short Tip Tears":CMTimeRange(start: CMTime(seconds: 85, preferredTimescale: 1), end: CMTime(seconds: 122, preferredTimescale: 1)), "1-Click Flare":CMTimeRange(start: CMTime(seconds: 111, preferredTimescale: 1), end: CMTime(seconds: 156, preferredTimescale: 1)), "Fades":CMTimeRange(start: CMTime(seconds: 73, preferredTimescale: 1), end: CMTime(seconds: 114, preferredTimescale: 1)), "2-Click Flare":CMTimeRange(start: CMTime(seconds: 78, preferredTimescale: 1), end: CMTime(seconds: 112, preferredTimescale: 1))]
    
    var skratchNames = ["Baby","Flare","Crabs (Crepes)","Swipes","Waves","Zig Zags", "Clover Tears", "Needle Dropping", "Scribbles", "Phazers", "Lazers", "Chirp Flare", "Chirps", "Drag", "Transformer", "Tip", "Tears", "Dicing", "Marches", "Reverse Cutting", "Cutting", "Long-short Tip Tears", "1-click Flare", "Fades", "2-Click Flare"]
    
    var battleNames = ["Battle Football", "Battle Smiley", "Battle Bunny", "Battle Spiderman", "Battle Gasmask", "Battle Devil", "Q-Bert Freestyle"]
    
    var equipmentSetupNames = ["Counting Bars",  "Cueing", "Slipmats Part 1", "Slipmats Part 2", "Setting Up Headshells", "Plugging In Turntables", "Turntable Adjustments","Mixer Basics", "EQ Scratching", "Preventing Skipping", "More Ways To Prevent Skipping","Cleaning Needles", "Fader Caps Adjustment", "Tuner Control Spray", "On Off Switch Adjustment", "How to seal leaky pipes"]
    
    var sections = [Key.Skratches.rawValue,Key.Battles.rawValue,Key.EquipmentSetup.rawValue]
    
    func loadVideoAtFaceIndexPath(){
        
        let section = sections[faceIndexPath.section]
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
        
        loadVideoByName(lastVideoWatched) { (completed) in
            queuePlayer?.play()
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
        
        let battleURL = Bundle.main.url(forResource: name, withExtension:"m4v")!
        
        let battleVideo = ThudRumbleVideoClip(name: name, loop: nil, angles: [], tracks: [], url: battleURL)
        
        videos[Key.Battles.rawValue]?.append(battleVideo)
        
    }
    
    func loadEquipmentSetupAssetForName(_ name:String){
        
        let equipmentSetupURL = Bundle.main.url(forResource: name, withExtension: "m4v")!
        
        let equipmentSetupVideo = ThudRumbleVideoClip(name: name, loop: nil, angles: [], tracks: [], url: equipmentSetupURL)
        
        videos[Key.EquipmentSetup.rawValue]?.append(equipmentSetupVideo)
        
    }
    
    
    func loadSkratchAssetForName(_ name:String,loop:CMTimeRange){
        
        let babyURL = Bundle.main.url(forResource: name, withExtension: "m4v")!
        //let baby2URL = Bundle.main.url(forResource: "\(name)2", withExtension: "m4v")!
        //let baby3URL = Bundle.main.url(forResource: "\(name)3", withExtension: "m4v")!
        //let baby4URL = Bundle.main.url(forResource: "\(name)4", withExtension: "m4v")!
        
        
        let babyVideo = ThudRumbleVideoClip(name: name, loop: loop, angles: [] /*["\(name)2","\(name)3","\(name)4"]*/, tracks: [], url: babyURL)
        //let baby2Video = ThudRumbleVideoClip(name: "\(name)2", loop: loop, angles: ["\(name)3","\(name)4",name], tracks: [], url: baby2URL)
        //let baby3Video = ThudRumbleVideoClip(name: "\(name)3", loop: loop, angles: ["\(name)4",name,"\(name)2"], tracks: [], url: baby3URL)
        //let baby4Video = ThudRumbleVideoClip(name: "\(name)4", loop: loop, angles: [name,"\(name)2","\(name)3"], tracks: [], url: baby4URL)
        
        
        videos[Key.Skratches.rawValue]?.append(babyVideo)
        //videos[Key.Skratches.rawValue]?.append(baby2Video)
        //videos[Key.Skratches.rawValue]?.append(baby3Video)
        //videos[Key.Skratches.rawValue]?.append(baby4Video)
        
        
    }
    
    
    func loadVideoByName(_ string:String,completion:(_ completed:Bool)->()){
        let arrayOfArrayOfVideos : [[ThudRumbleVideoClip]] = videos.map { (arg: (key: String, value: [ThudRumbleVideoClip])) -> [ThudRumbleVideoClip] in

            let (_, value) = arg
            return value
        }
        let arrayOfVideos = arrayOfArrayOfVideos.flatMap{$0}
        let matchingVideo = arrayOfVideos.filter { (video) -> Bool in
            if video.name == string {
                return true
            }
            else {
                return false
            }
        }.first
        if matchingVideo != nil {
            playerItem = AVPlayerItem(url: matchingVideo!.url)
            queuePlayer = AVQueuePlayer(playerItem: playerItem)
            if matchingVideo!.loop != nil {
                playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem!, timeRange: matchingVideo!.loop!)
            }
            else {
                playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem:playerItem!)
            }

            viewController.setLayerPlayerLooper(queuePlayer!)
            completion(true)
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

