//
//  CancelNightTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 6/2/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class CancelNightTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Style the cancel button
        cancelButton.layer.cornerRadius = 6
        cancelButton.layer.borderColor = Colors.teal.cgColor
        cancelButton.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
