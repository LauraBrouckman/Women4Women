//
//  EditHomeLocationTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 6/2/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit

class EditHomeLocationTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var homeLocationLabel: UILabel!
    
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        let street = UserDefaults.getHomeStreet()
        if street.isEmpty {
            homeLocationLabel.text = "Not set"
        } else {
            homeLocationLabel.text = street
        }
        // Initialization code
        setButton.isHidden = true
        textField.isHidden = true
        textField.delegate = self
        textField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func updateHomeLocation() {
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
    
    func callback() {
        homeLocationLabel.text = UserDefaults.getHomeStreet()
    }


    @IBAction func setHomeLocation(_ sender: UIButton) {
        updateHomeLocation()
        setButton.isHidden = true
        textField.isHidden = true
        editButton.isHidden = false
        homeLocationLabel.isHidden = false
    }
    
    @IBAction func editHomeLocation(_ sender: UIButton) {
        setButton.isHidden = false
        textField.isHidden = false
        editButton.isHidden = true
        homeLocationLabel.isHidden = true
        textField.text = UserDefaults.getHomeStreet()
    }

}
