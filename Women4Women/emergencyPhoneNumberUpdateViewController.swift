//
//  emergencyPhoneNumberUpdateViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/12/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class emergencyPhoneNumberUpdateViewController: UIViewController {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.text = UserDefaults.getEmergencyContactPhoneNumber()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updatePhoneNumber(_ sender: Any) {
        UserDefaults.setEmergencyContactPhoneNumber(phoneNumberTextField.text!)
        
    }

}
