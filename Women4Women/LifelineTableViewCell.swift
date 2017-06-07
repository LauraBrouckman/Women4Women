//
//  LifelineTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/23/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class LifelineTableViewCell: UITableViewCell {

    @IBOutlet weak var lifelineProfilePicture: UIImageView!
    @IBOutlet weak var lifelineNameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    var username: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
