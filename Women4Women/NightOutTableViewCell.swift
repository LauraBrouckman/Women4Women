//
//  NightOutTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 6/2/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class NightOutTableViewCell: UITableViewCell {

    @IBOutlet weak var nightLocationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nightLocationLabel.text = UserDefaults.getNightOutLocationName()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
