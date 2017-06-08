//
//  TimeTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/17/17.
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
            UserDefaults.setHomeTime(newDate)
        }
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.borderColor = UIColor.black.cgColor
        datePicker.layer.borderWidth = 1
    }
    
    //Make sure that date is after current time
    fileprivate func ensureDateIsTomorrow(_ date: Date) -> Date{
        let currentDay = Date()
        var newDate = date
        if (currentDay as NSDate).earlierDate(date) == date {
            newDate = date.addingTimeInterval(60*60*24)
        }
        return newDate
    }
    
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        UserDefaults.setHomeTime(ensureDateIsTomorrow(datePicker.date))
        self.callback?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
