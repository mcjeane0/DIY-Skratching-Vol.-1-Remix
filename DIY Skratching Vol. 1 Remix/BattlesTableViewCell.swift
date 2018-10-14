//
//  BattlesTableViewCell.swift
//  DIY Skratching Vol. 1 Remix
//
//  Created by Arjun Iyer on 9/17/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit

class BattlesTableViewCell: UITableViewCell {

    var battleName : String! {
        didSet {
            textLabel?.text = battleName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
