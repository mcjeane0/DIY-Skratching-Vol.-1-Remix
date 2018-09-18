//
//  ViewController.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 9/14/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit
import AVKit


extension ViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case battlesTable:
            delegate?.didSelectRowInBattlesTable(indexPath: indexPath)
            break
        case skratchesTable:
            delegate?.didSelectRowInSkratchesTable(indexPath: indexPath)
            break
        case mainMenuTable:
            delegate?.didSelectRowInMainMenuTable(indexPath: indexPath)
            break
        case equipmentSetupTable:
            delegate?.didSelectRowInEquipmentSetupTable(indexPath: indexPath)
            break
        default:
            break
        }
    }

}

protocol ViewControllerDelegate {
    func didSelectRowInBattlesTable(indexPath:IndexPath)
    func didSelectRowInSkratchesTable(indexPath:IndexPath)
    func didSelectRowInMainMenuTable(indexPath:IndexPath)
    func didSelectRowInEquipmentSetupTable(indexPath:IndexPath)
}

class ViewController: UIViewController {

    var videoLayer : AVPlayerLayer?

    @IBOutlet weak var audioTrackButton: UIButton!
    @IBOutlet weak var videoAngleButton: UIButton!


    var rightSwipeEquipmentSetupGestureRecognizer : UISwipeGestureRecognizer?

    var rightSwipeBattleGestureRecognizer : UISwipeGestureRecognizer?

    var twoFingerTapSkratchVideoGestureRecognizer : UITapGestureRecognizer?
    var longPressSkratchVideoGestureRecognizer : UILongPressGestureRecognizer?
    var tapSkratchVideoGestureRecognizer : UITapGestureRecognizer?
    var panSkratchVideoGestureRecognizer : UIPanGestureRecognizer?
    var downSwipeSkratchVideoGestureRecognizer : UISwipeGestureRecognizer?
    var upSwipeSkratchVideoGestureRecognizer : UISwipeGestureRecognizer?
    var rightSwipeSkratchVideoGestureRecognizer : UISwipeGestureRecognizer?
    var leftSwipeSkratchVideoGestureRecognizer : UISwipeGestureRecognizer?

    var rightSwipeSkratchMenuGestureRecognizer : UISwipeGestureRecognizer?


    static let viewDidLoadNotification = Notification.Name("ViewControllerViewDidLoad")

    @IBOutlet weak var skratchVideoView : UIView!

    var delegate : ViewControllerDelegate?

    @IBOutlet weak var battlesTable: UITableView!
    @IBOutlet weak var skratchesTable: UITableView!
    @IBOutlet weak var equipmentSetupTable: UITableView!
    @IBOutlet weak var mainMenuTable: UITableView!


    func setLayerPlayerLooper(_ player:AVPlayerLooper)

    func showBattlesTable(){
        DispatchQueue.main.async {
            self.battlesTable.isHidden = false
            self.skratchesTable.isHidden = true
            self.equipmentSetupTable.isHidden = true
            self.mainMenuTable.isHidden = true
        }
    }

    func showEquipmentSetupTable(){
        DispatchQueue.main.async {
            self.battlesTable.isHidden = true
            self.skratchesTable.isHidden = true
            self.equipmentSetupTable.isHidden = false
            self.mainMenuTable.isHidden = true
        }
    }

    func showSkratchesTable(){
        DispatchQueue.main.async {
            self.battlesTable.isHidden = true
            self.skratchesTable.isHidden = false
            self.equipmentSetupTable.isHidden = true
            self.mainMenuTable.isHidden = true
        }
    }

    func showMainMenuTable(){
        DispatchQueue.main.async {
            self.battlesTable.isHidden = true
            self.skratchesTable.isHidden = true
            self.equipmentSetupTable.isHidden = true
            self.mainMenuTable.isHidden = false
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.post(name: ViewController.viewDidLoadNotification, object: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

