//
//  EditTimeHomeTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 6/2/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class EditTimeHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeHomeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setTimeLabel()
    
        let time = UserDefaults.getHomeTime()
        print("USER DEFAULTS HOME TIME IS \(time)")

        // Initialization code
        
        datePicker.date = time!
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.borderColor = UIColor.black.cgColor
        datePicker.layer.borderWidth = 1
        datePicker.isHidden = true
        
        setButton.isHidden = true
    }
    
    fileprivate func setTimeLabel() {
        var timeString: String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let time = UserDefaults.getHomeTime()
        timeString = dateFormatter.string(from: time!)
        
        timeHomeLabel.text = timeString
    }

    @IBAction func updateTime(_ sender: UIButton) {
        UserDefaults.setHomeTime(datePicker.date)
        setTimeLabel()
        editButton.isHidden = false
        setButton.isHidden = true
        datePicker.isHidden = true
        timeHomeLabel.isHidden = false
        
    }
    
    @IBAction func editTime(_ sender: UIButton) {
        editButton.isHidden = true
        setButton.isHidden = false
        datePicker.isHidden = false
        timeHomeLabel.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
