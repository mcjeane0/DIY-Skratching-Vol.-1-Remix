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

    init(name:String,loop:CMTimeRange?,angles:[String],tracks:[String],url:URL){
        self.name = name
        self.loop = loop
        self.angles = angles
        self.tracks = string
        self.url = url

    }

}

extension AppDelegate : ViewControllerDelegate {

    func didSelectRowInBattlesTable(indexPath: IndexPath) {
        let selectedVideo = videos["Battles"]![indexPath.row]
        loadVideoByName(selectedVideo.name) { (completed) in
            if completed {

            }
            else {

            }
        }
    }

    func didSelectRowInSkratchesTable(indexPath: IndexPath) {
        let selectedVideo = videos["Skratches"]![indexPath.row]
        loadVideoByName(selectedVideo.name) { (completed) in
            if completed {

            }
            else {

            }
        }
    }

    func didSelectRowInMainMenuTable(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            viewController.showEquipmentSetupTable()
            break
        case 1:
            viewController.showSkratchesTable()
            break
        case 2:
            viewController.showBattlesTable()
            break
        default:
            break
        }
    }

    func didSelectRowInEquipmentSetupTable(indexPath: IndexPath) {
        let selectedVideo = videos["Equipment Setup"]![indexPath.row]
        loadVideoByName(selectedVideo.name) { (completed) in
            if completed {

            }
            else {

            }
        }
    }




}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var selectedTrack : Int = 1
    var selectedAngle : Int = 1

    var viewController : ViewController!

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


    var videos : [String:[ThudRumbleVideoClip]] = [
                                    "Skratches":[
                                        ThudRumbleVideoClip(name: "baby", loop: CMTimeRange(start: CMTimeMakeWithSeconds(13.0, 1), duration: CMTimeMakeWithSeconds(13.0, 1)), angles: ["baby1","baby3","baby4"], tracks: ["baby1","baby2"], url: Bundle.main.url(forResource: "baby", withExtension: ".mp4")),

                                    ],
                                    "Equipment Setup":[

                                    ],
                                    "Battles":[

                                    ],
                                                ]
    var playerLooper : AVPlayerLooper?
    var window: UIWindow?

    func loadVideoByName(_ string:String,completion:(_ completed:Bool)->()){
        let arrayOfArrayOfVideos : [[ThudRumbleVideoClip]] = videos.map { (arg: (key: String, value: [ThudRumbleVideoClip])) -> [ThudRumbleVideoClip] in

            let (key, value) = arg
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
            if matchingVideo!.loop != nil {
                playerLooper = AVPlayerLooper(player: AVQueuePlayer(playerItem: nil), templateItem: AVPlayerItem(url: matchingVideo!.url), timeRange: matchingVideo!.loop!)
            }
            else {
                playerLooper = AVPlayerLooper(player: AVQueuePlayer(playerItem: nil), templateItem: AVPlayerItem(url:matchingVideo!.url))
            }

            viewController.setLayerPlayerLooper(playerLooper!)
            completion(true)
        }
        else {
            completion(false)
        }
    }

    @objc func viewDidLoad(_ notification:Notification){
        if let viewController = notification.object as? ViewController {
            viewController.delegate = self
            self.viewController = viewController
            loadVideoByName(lastVideoWatched) { (completed) in
                if completed {
                    NSLog("completed")
                    switch lastVideoWatched {
                    case "none":
                        // MARK: Show main menu
                        viewController.showMainMenuTable()
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
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoad(_:)), name: ViewController.viewDidLoadNotification, object: nil)
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

