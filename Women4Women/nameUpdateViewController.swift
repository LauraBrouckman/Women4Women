//
//  nameUpdateViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/11/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class nameUpdateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = UserDefaults.getFirstName()
        lastNameTextField.text = UserDefaults.getLastName()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        firstNameTextField.tag = 0
        lastNameTextField.tag = 1
        
        //updateButton.
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
    
    @IBAction func updateName(_ sender: Any) {
        if firstNameTextField.text == "" || lastNameTextField.text == "" {
            displayAlertMessage(alertMessage: "You must fill in the fields for first and last name")
        }
        UserDefaults.setFirstName(firstNameTextField.text!)
        UserDefaults.setLastName(lastNameTextField.text!)
        RemoteDatabase.updateUserName(forUser: UserDefaults.getUsername(), firstName: firstNameTextField.text!, lastName: lastNameTextField.text!)
    }
    
    func displayAlertMessage(alertMessage:String) {
        
        let myAlert = UIAlertController(title:"Notice", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        
        myAlert.addAction(okAction)
        
        UIApplication.topViewController()?.present(myAlert, animated: true, completion: nil)
    }

    
    

}
