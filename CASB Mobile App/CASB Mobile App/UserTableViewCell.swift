//
//  UserTableViewCell.swift
//  CASB Mobile App
//
//  Created by Jack Barnett on 11/1/18.
//  Copyright © 2018 Jack Barnett. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    /* Properties */
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var riskLevelLabel: UILabel!
    @IBOutlet weak var riskScoreLabel: UILabel!
    @IBOutlet weak var appInstanceLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    /* Methods */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
