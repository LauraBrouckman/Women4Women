//
//  LoginViewController.swift
//  Women4Women
//
//  Created by Marina Elmore on 5/15/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        let loginUsername = username.text;
        let loginPassword = password.text;
        
        //Get username and password
        let usernameStored = UserDefaults.getUsername();
        let passwordStored = UserDefaults.getPassword();
        
        
        //Check if they match
        if (loginUsername == usernameStored){
            if (loginPassword == passwordStored){
                
                //Login Successful!
                UserDefaults.setLoggedIn(on: true);
                
                //Dismiss Login View
                self.dismiss(animated: true, completion: nil);
            }else{
                //Password wrong
                displayAlertMessage(alertMessage: "Incorrect Password, Please Try Again.");
            }
        }else{
            //User name wrong
            displayAlertMessage(alertMessage: "Incorrect Username, Please Try Again.");
            
        }
        
    }
    
    func displayAlertMessage(alertMessage:String){
        let myAlert = UIAlertController(title:"Notice", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil);
    }
    
    

}
