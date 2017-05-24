//
//  RegisterViewController.swift
//  Women4Women
//
//  Created by Marina Elmore on 5/15/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var firstName: UITextField! 
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var zip: UITextField!

    @IBAction func registerUser(_ sender: UIButton) {
        let userFirstName = firstName.text!
        let userLastName = lastName.text!
        let userUsername = username.text!
        let userPassword = password.text!

        //Check for empty fields

        if ((userFirstName.isEmpty) || (userLastName.isEmpty) || (userUsername.isEmpty) || (userPassword.isEmpty)){

            //Display alert message
            displayAlertMessage(alertMessage: "All fields are required.")
            return

        }

        // Check if that username is already in user
        RemoteDatabase.getUserFromDB(userUsername) { user in
            if user == nil {
                self.createUser(username: userUsername, firstName: userFirstName, lastName: userLastName, password: userPassword)
            }
            //username has been taken
            else {
                self.displayAlertMessage(alertMessage: "This username has already been taken")
            }
        }
    }
    
    @IBAction func joinButton(_ sender: UIButton) {
        let userStreet = street.text!;
        let userCity = city.text!;
        let userCountry = country.text!;
        let userZip = zip.text!;
        self.addAddress(streetText: userStreet, cityText:userCity, countryText:userCountry, zipText: userZip);
    
    }
    
    func addAddress(streetText:String, cityText:String, countryText:String, zipText:String){
        
        //Store Data
        let ad = streetText+", "+cityText+", "+zipText+", "+countryText;
        UserDefaults.getCoordinatesFromAddressName(address: ad,title: "");
        UserDefaults.setHomeCity(cityText);
        UserDefaults.setHomeStreet(streetText);
        UserDefaults.setHomeCountry(countryText);
        UserDefaults.setHomeZip(zipText);

        
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
    
    func createUser(username: String, firstName: String, lastName: String, password: String) {
        //Store Data
        UserDefaults.setFirstName(firstName)
        UserDefaults.setLastName(lastName)
        UserDefaults.setPassword(password)
        UserDefaults.setUsername(username)
        UserDefaults.setLoggedIn(on: true)
        UserDefaults.setAppOpenedBefore(true)
        RemoteDatabase.addNewUser(username, password: password, firstName: firstName, lastName: lastName, locationLat: 0.0, locationLon: 0.0)
        
        self.performSegue(withIdentifier: "registerAddress", sender: self);
        

    }
    
    func displayAlertMessage(alertMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        
        myAlert.addAction(okAction)
        
        
        UIApplication.topViewController()?.present(myAlert, animated: true, completion: nil)
    }
    

}
