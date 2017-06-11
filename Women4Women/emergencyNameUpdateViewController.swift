//
//  emergencyNameUpdateViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/12/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class emergencyNameUpdateViewController: UIViewController {

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = UserDefaults.getEmergencyContactFirstName()
        lastNameTextField.text = UserDefaults.getEmergencyContactLastName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateName(_ sender: Any) {
        UserDefaults.setEmergencyContactFirstName(firstNameTextField.text!)
        UserDefaults.setEmergencyContactLastName(lastNameTextField.text!)
    }
  


}
