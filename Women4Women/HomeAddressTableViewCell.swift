//
//  HomeAddressTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/18/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit

class HomeAddressTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var callback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let street = UserDefaults.getHomeStreet()
        let city = UserDefaults.getHomeCity()
        if street.isEmpty {
            textField.text = ""
        } else {
            textField.text = street + " " + city
        }
        updateButton.backgroundColor = UIColor.white
        updateButton.setTitleColor(UIColor.black, for: .normal)
        updateButton.layer.cornerRadius = 6
        textField.delegate = self
        textField.returnKeyType = .done
        // Initialization code
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
                    UserDefaults.setHomeLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    UserDefaults.getAddressNameFromCoordinates(self.callback)
                    
                } else {
                    print("error \($1)")
                }
            }
        }
    }

}
