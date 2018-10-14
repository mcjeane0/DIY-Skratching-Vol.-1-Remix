//
//  AppDelegate.swift
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

extension AppDelegate : FaceDelegate {
    
    func handleSwipeUp() {
        let nextPossibleSection = self.faceIndexPath.section + 1
    }
    
    func handleSwipeDown() {
        
    }
    
    func handleSwipeLeft() {
        
    }
    
    func handleSwipeRight() {
        
    }

}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

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

    var lastVideoWatched : String {
        get {
            if let value = UserDefaults.standard.string(forKey: Key.lastVideoWatched.rawValue) {
                return value
            }
            return "none"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.lastVideoWatched.rawValue)
        }
    }


    var videos : [String:[ThudRumbleVideoClip]] = [Key.Skratches.rawValue:[],
                                                   Key.EquipmentSetup.rawValue:[],
                                                   Key.Battles.rawValue:[]]
    var playerLooper : AVPlayerLooper?
    var queuePlayer : AVQueuePlayer?
    var playerItem : AVPlayerItem?
    var window: UIWindow?

    var skratchLoops : [String:CMTimeRange] = ["baby":CMTimeRange(start: CMTime(seconds: 59, preferredTimescale: 1), end: CMTime(seconds: 84, preferredTimescale: 1)),"flare":CMTimeRange(start: CMTime(seconds: 133, preferredTimescale: 1), end: CMTime(seconds: 166, preferredTimescale: 1)),"crab":CMTimeRange(start: CMTime(seconds: 100, preferredTimescale: 1), end: CMTime(seconds: 141, preferredTimescale: 1)),"swipes":CMTimeRange(start: CMTime(seconds: 61, preferredTimescale: 1), end: CMTime(seconds: 80, preferredTimescale: 1)),"waves":CMTimeRange(start: CMTime(seconds: 58, preferredTimescale: 1), end: CMTime(seconds: 95, preferredTimescale: 1)),"zig zags":CMTimeRange(start: CMTime(seconds: 50, preferredTimescale: 1), end: CMTime(seconds: 69, preferredTimescale: 1)), "clover tears":CMTimeRange(start: CMTime(seconds: 63, preferredTimescale: 1), end: CMTime(seconds: 81, preferredTimescale: 1)), "needle dropping":CMTimeRange(start: CMTime(seconds: 81, preferredTimescale: 1), end: CMTime(seconds: 109, preferredTimescale: 1)), "scribbles":CMTimeRange(start: CMTime(seconds: 90, preferredTimescale: 1), end: CMTime(seconds: 137, preferredTimescale: 1)), "phazers":CMTimeRange(start: CMTime(seconds: 44, preferredTimescale: 1), end: CMTime(seconds: 64, preferredTimescale: 1)), "lazers":CMTimeRange(start: CMTime(seconds: 64, preferredTimescale: 1), end: CMTime(seconds: 85, preferredTimescale: 1)), "chirp flare":CMTimeRange(start: CMTime(seconds: 73, preferredTimescale: 1), end: CMTime(seconds: 114, preferredTimescale: 1)), "chirps":CMTimeRange(start: CMTime(seconds: 82, preferredTimescale: 1), end: CMTime(seconds: 103, preferredTimescale: 1)), "drag":CMTimeRange(start: CMTime(seconds: 54, preferredTimescale: 1), end: CMTime(seconds: 94, preferredTimescale: 1)), "transformer":CMTimeRange(start: CMTime(seconds: 96, preferredTimescale: 1), end: CMTime(seconds: 142, preferredTimescale: 1)), "tip":CMTimeRange(start: CMTime(seconds: 45, preferredTimescale: 1), end: CMTime(seconds: 64, preferredTimescale: 1)), "tears":CMTimeRange(start: CMTime(seconds: 82, preferredTimescale: 1), end: CMTime(seconds: 121, preferredTimescale: 1)), "dicing":CMTimeRange(start: CMTime(seconds: 78, preferredTimescale: 1), end: CMTime(seconds: 124, preferredTimescale: 1)), "marches":CMTimeRange(start: CMTime(seconds: 71, preferredTimescale: 1), end: CMTime(seconds: 95, preferredTimescale: 1)), "reverse cutting":CMTimeRange(start: CMTime(seconds: 47, preferredTimescale: 1), end: CMTime(seconds: 96, preferredTimescale: 1)), "cutting":CMTimeRange(start: CMTime(seconds: 59, preferredTimescale: 1), end: CMTime(seconds: 84, preferredTimescale: 1)), "long-short tip tears":CMTimeRange(start: CMTime(seconds: 85, preferredTimescale: 1), end: CMTime(seconds: 122, preferredTimescale: 1)), "1-click flare":CMTimeRange(start: CMTime(seconds: 111, preferredTimescale: 1), end: CMTime(seconds: 156, preferredTimescale: 1)), "fades":CMTimeRange(start: CMTime(seconds: 73, preferredTimescale: 1), end: CMTime(seconds: 114, preferredTimescale: 1)), "2-click flares":CMTimeRange(start: CMTime(seconds: 78, preferredTimescale: 1), end: CMTime(seconds: 112, preferredTimescale: 1))]
    
    var skratchNames = ["baby","flare","crab","swipes","waves","zig zags", "clover tears", "needle dropping", "scribbles", "phazers", "lazers", "chirp flare", "chirps", "drag", "transformer", "tip", "tears", "dicing", "marches", "reverse cutting", "cutting", "long-short tip tears", "1-click flare", "fades", "2-click flares"]
    
    var battleNames = ["Battle Football", "Battle Smiley", "Battle Bunny", "Battle Spiderman", "Battle Gasmask", "Battle Devil", "Q-Bert Freestyle"]
    
    var equipmentSetupNames = ["Counting Bars",  "Cueing", "Slipmats Part 1", "Slipmats Part 2", "Setting Up Headshells", "Plugging In Turntables", "Turntable Adjustments","Mixer Basics", "EQ Scratching", "Preventing Skipping", "More Ways To Prevent Skipping","Cleaning Needles", "Fader Caps Adjustment", "Tuner Control Spray", "On Off Switch Adjustment", "How to seal leaky pipes"]
    
    var sections = ["skratches","battles","equipment"]
    
    
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
        
        
        let babyVideo = ThudRumbleVideoClip(name: name, loop: loop, angles: ["\(name)2","\(name)3","\(name)4"], tracks: [], url: babyURL)
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

    @objc func viewDidLoad(_ notification:Notification){
        if let viewController = notification.object as? Face {
            viewController.delegate = self
            self.viewController = viewController
            loadVideoByName(lastVideoWatched) { (completed) in
                if completed {
                    NSLog("completed")
                    switch lastVideoWatched {
                    case "none":
                        // MARK: Show main menu
                        
                        break
                    default:
                        break
                    }
                }
                else {
                    NSLog("!completed")
                }
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoad(_:)), name: Face.viewDidLoadNotification, object: nil)
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

