//
//  homeAddressUpdateViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/12/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class homeAddressUpdateViewController: UIViewController {

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
   
        let ad = UserDefaults.getHomeStreet()+", "+UserDefaults.getHomeCity() + ", " + UserDefaults.getHomeZip() + ", " + UserDefaults.getHomeCountry()
        
        UserDefaults.getCoordinatesFromAddressName(address: ad,title: "")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
