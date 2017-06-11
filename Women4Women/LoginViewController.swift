//
//  LoginViewController.swift
//  Women4Women
//
//  Created by Marina Elmore on 5/15/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.tag = 0
        password.tag = 1
        username.delegate = self
        password.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        let loginUsername = username.text;
        let loginPassword = password.text;
        
        if (loginPassword == nil || loginPassword! == "")  {
            displayAlertMessage(alertMessage: "Incorect password, please try again")
            return
        }
        
        if (loginUsername! == "")  {
            displayAlertMessage(alertMessage: "Please enter a username")
            return
        }
        
        if let username = loginUsername {
            let user = RemoteDatabase.getUserFromDB(username) { user in
                if user == nil {
                    self.displayAlertMessage(alertMessage: "Incorrect username, please try again")
                }
                else {
                    if let snapshotDict = user as? NSDictionary {
                        let password = snapshotDict["password"] as! String
                        if password != loginPassword {
                            self.displayAlertMessage(alertMessage: "Incorect password, please try again")
                        } else {
                            UserDefaults.setLoggedIn(on: true)
                            UserDefaults.setAppOpenedBefore(true)
                            UserDefaults.setUsername(username)
                            UserDefaults.setFirstName(snapshotDict["first_name"] as! String)
                            UserDefaults.setLastName(snapshotDict["last_name"] as! String)
                            UserDefaults.setProfilePicFilename("test")
                            RemoteDatabase.downloadFileToLocal(forUser: username, completionHandler: self.completion)
                            let containerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Container")
                            UIApplication.topViewController()?.present(containerViewController, animated: true, completion: nil)                        }
                    }
                }
            }
        }
    }
    
    fileprivate func completion (_ done: Bool) {
        if(done) {
            print("worked")
        }
    }
    
    
    
    func displayAlertMessage(alertMessage:String) {
    
        let myAlert = UIAlertController(title:"Notice", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        
        myAlert.addAction(okAction)
        
        UIApplication.topViewController()?.present(myAlert, animated: true, completion: nil)
    }
    
    
    
}


// code to get rid of keyboard when you tap elsewhere
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
