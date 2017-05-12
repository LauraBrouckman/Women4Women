//
//  SettingsViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit

class SettingsViewController: UIViewController {
    
    
    
    @IBOutlet weak var firstNameButton: UIButton!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var homeAddressButton: UIButton!
    @IBOutlet weak var homeAddressLabel2: UILabel!
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.setUsername("lkurt17")
        firstNameLabel.text = UserDefaults.getFirstName()
        firstNameButton.layer.borderWidth = 1
        firstNameButton.layer.borderColor = UIColor.lightGray.cgColor
        
        lastNameLabel.text = UserDefaults.getLastName()

        
        
        
        
//        var test = UserDefaults.getAddressNameFromCoordinates()
//        print(test)
        homeAddressLabel.text = UserDefaults.getHomeLocationName()
        homeAddressLabel2.text = UserDefaults.getHomeStreet() + ", " + UserDefaults.getHomeCity()
        homeAddressButton.layer.borderWidth = 1
        homeAddressButton.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
