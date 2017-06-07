//
//  RegisterAddressViewController.swift
//  Women4Women
//
//  Created by Laura Brouckman on 6/7/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class RegisterAddressViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var street: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        street.delegate = self
        city.delegate = self
        country.delegate = self
        zip.delegate = self
        state.delegate = self
        
        street.tag = 0
        city.tag = 1
        country.tag = 4
        zip.tag = 3
        state.tag = 2
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
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
    
    @IBAction func joinButton(_ sender: UIButton) {
        let userStreet = street.text!;
        let userCity = city.text!;
        let userCountry = country.text!;
        let userZip = zip.text!;
        let userState = state.text!
        self.addAddress(streetText: userStreet, cityText:userCity, countryText:userCountry, zipText: userZip, stateText: userState);
        
    }
    
    func addAddress(streetText:String, cityText:String, countryText:String, zipText:String, stateText:String){
        
        //Store Data
        let ad = streetText+", "+cityText+", "+zipText+", "+countryText;
        UserDefaults.getCoordinatesFromAddressName(address: ad,title: "");
        UserDefaults.setHomeCity(cityText);
        UserDefaults.setHomeStreet(streetText);
        UserDefaults.setHomeCountry(countryText);
        UserDefaults.setHomeZip(zipText);
        UserDefaults.setHomeState(stateText);
        
        
        //Display alert message with confirmation
        let successAlert = UIAlertController(title:"Congratulations!", message:"Registration is Successful! Welcome to W4W!", preferredStyle: UIAlertControllerStyle.alert)
        
        let yayAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default){
            action in
            let containerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Container")
            UIApplication.topViewController()?.present(containerViewController, animated: true, completion: nil)
        }
        
        successAlert.addAction(yayAction)
        UIApplication.topViewController()?.present(successAlert, animated: true, completion: nil)
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
