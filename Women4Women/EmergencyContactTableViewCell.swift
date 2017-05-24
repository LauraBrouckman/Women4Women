//
//  EmergencyContactTableViewCell.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/20/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class EmergencyContactTableViewCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var emergencyContactLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emergencyContactLabel.text = UserDefaults.getEmergencyContactFirstName() + " " + UserDefaults.getEmergencyContactLastName()
        editButton.layer.cornerRadius = 6
        editButton.backgroundColor = UIColor.white
        editButton.setTitleColor(UIColor.black, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
