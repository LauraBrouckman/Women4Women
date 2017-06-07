//
//  LoginRegisterViewController.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/6/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let userLoggedIn = UserDefaults.getLoggedIn()
        
        if (!userLoggedIn){
            
            self.performSegue(withIdentifier: "loginView", sender: self);
        }
        
    }

    @IBAction func logoutUser(_ sender: UIButton) {
        UserDefaults.setLoggedIn(on: false);
        self.performSegue(withIdentifier: "loginView", sender: self);
    
    }
}
