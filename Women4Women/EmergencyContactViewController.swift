//
//  EmergencyContactViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class EmergencyContactViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameButton: UIButton!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameButton.layer.borderWidth = 1
        firstNameButton.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberButton.layer.borderWidth = 1
        phoneNumberButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameLabel.text = UserDefaults.getEmergencyContactFirstName()
        lastNameLabel.text = UserDefaults.getEmergencyContactLastName()
        phoneNumberLabel.text = UserDefaults.getEmergencyContactPhoneNumber()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
