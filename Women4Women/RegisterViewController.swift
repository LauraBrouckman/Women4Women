//
//  RegisterViewController.swift
//  Women4Women
//
//  Created by Marina Elmore on 5/15/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.delegate = self
        lastName.delegate = self
        username.delegate = self
        password.delegate = self
        
        firstName.tag = 0
        lastName.tag = 1
        username.tag = 2
        password.tag = 3
        

        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()

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
    
    @IBOutlet weak var scrollView: UIScrollView!
    var activeField: UITextField?
    
    @IBOutlet weak var firstName: UITextField! 
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
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
    
    
    // Code to move the screen up when the keyboard is opened
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }


}
