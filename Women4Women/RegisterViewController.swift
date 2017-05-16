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
    
    
    @IBAction func registerUser(_ sender: UIButton) {
        let userFirstName = firstName.text!;
        let userLastName = lastName.text!;
        let userUsername = username.text!;
        let userPassword = password.text!;

        //Check for empty fields

        if ((userFirstName.isEmpty) || (userLastName.isEmpty) || (userUsername.isEmpty) || (userPassword.isEmpty)){

            //Display alert message
            displayAlertMessage(alertMessage: "All fields required.");
            return;

        }


        //Store Data
        UserDefaults.setFirstName(userFirstName);
        UserDefaults.setLastName(userLastName);
        UserDefaults.setPassword(userPassword);
        UserDefaults.setUsername(userUsername);


        //Display alert message with confirmation
        let successAlert = UIAlertController(title:"Alert", message:"Registration is Successful! Welcome to W4W!", preferredStyle: UIAlertControllerStyle.alert);

        let yayAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default){
            action in self.dismiss(animated: true, completion:nil);
        };
        
        successAlert.addAction(yayAction);
        self.present(successAlert, animated: true, completion: nil);
    }

    
    func displayAlertMessage(alertMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }
    

}
