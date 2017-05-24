//
//  HomeAddressTableViewCell.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/18/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit

class HomeAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var callback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.text = UserDefaults.getHomeStreet() + " " + UserDefaults.getHomeCity()
        updateButton.backgroundColor = UIColor.white
        updateButton.setTitleColor(UIColor.black, for: .normal)
        updateButton.layer.cornerRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func updateHomeAddress() {
        if let newAddress = textField.text {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(newAddress) {
                if let placemarks = $0 {
                    let coordinate = (placemarks[0].location?.coordinate)!
                    // Update your location remotely and in local storage
                    print(coordinate)
                    UserDefaults.setHomeLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    UserDefaults.getAddressNameFromCoordinates(self.callback)
                    
                } else {
                    print("error \($1)")
                }
            }
        }
    }

}
