//
//  nameUpdateViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/11/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class nameUpdateViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = UserDefaults.getFirstName()
        lastNameTextField.text = UserDefaults.getLastName()
        
        //updateButton.
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateName(_ sender: Any) {
        UserDefaults.setFirstName(firstNameTextField.text!)
        UserDefaults.setLastName(lastNameTextField.text!)
    }

//    @IBAction func updateFields(sender: UIButton) {
//        print("test")
//    }
//    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
