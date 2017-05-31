//
//  TimeTableViewCell.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/17/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {


    
    @IBOutlet weak var datePicker: UIDatePicker!

    var callback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let time = UserDefaults.getHomeTime() {
            datePicker.date = time
        } else {
            let newDate = Date(timeIntervalSinceNow: TimeInterval(7200))
            datePicker.date = Date(timeIntervalSinceNow: TimeInterval(7200))
        }
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.borderColor = UIColor.black.cgColor
        datePicker.layer.borderWidth = 1
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        UserDefaults.setHomeTime(sender.date)
        self.callback?()
        // When this happens we need to be updating the parent cell somehow...
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
