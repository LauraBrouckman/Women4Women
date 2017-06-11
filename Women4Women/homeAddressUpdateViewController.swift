//
//  homeAddressUpdateViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/12/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class homeAddressUpdateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var streetText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var stateText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        streetText.text = UserDefaults.getHomeStreet()
        cityText.text = UserDefaults.getHomeCity()
        zipText.text = UserDefaults.getHomeZip()
        countryText.text = UserDefaults.getHomeCountry()
        stateText.text = UserDefaults.getHomeState()
        
        streetText.delegate = self
        cityText.delegate = self
        zipText.delegate = self
        countryText.delegate = self
        stateText.delegate = self
        
        streetText.returnKeyType = UIReturnKeyType.next
        cityText.returnKeyType = UIReturnKeyType.next
        zipText.returnKeyType = UIReturnKeyType.next
        stateText.returnKeyType = UIReturnKeyType.next
        countryText.returnKeyType = UIReturnKeyType.done
        
        streetText.tag = 0
        cityText.tag = 1
        stateText.tag = 2
        zipText.tag = 3
        countryText.tag = 4
        
        self.hideKeyboardWhenTappedAround()

        
        let ad = UserDefaults.getHomeStreet()+", "+UserDefaults.getHomeCity() + ", " + UserDefaults.getHomeZip() + ", " + UserDefaults.getHomeCountry()
        
        UserDefaults.getCoordinatesFromAddressName(address: ad,title: "")
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateAddress(_ sender: Any) {
        let ad = streetText.text!+", "+cityText.text!+", "+zipText.text!+", "+countryText.text!
        
        UserDefaults.getCoordinatesFromAddressName(address: ad,title: "")
        UserDefaults.setHomeCity(cityText.text!)
        UserDefaults.setHomeStreet(streetText.text!)
        UserDefaults.setHomeCountry(countryText.text!)
        UserDefaults.setHomeZip(zipText.text!)
        UserDefaults.setHomeState(stateText.text!)
        
    }


}
