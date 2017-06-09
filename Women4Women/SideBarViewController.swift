//
//  SideBarViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/17/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profileThumbnail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = UserDefaults.getFirstName()
        profileThumbnail.layer.cornerRadius = profileThumbnail.frame.size.width / 2;
        profileThumbnail.clipsToBounds = true
        //logoutButton.
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(UserDefaults.getProfilePicFilename()).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            profileThumbnail.image = UIImage(contentsOfFile: filePath)
        }
    }
    

    @IBAction func logoutUser(_ sender: Any) {
        
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.setLoggedIn(on: false);
            UserDefaults.setNightOccuring(false)
            self.performSegue(withIdentifier: "logoutSegue", sender: self);
            
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancel")
        }))
        
        present(logoutAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func pressedSettings() {
        self.slideMenuController()?.performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    @IBAction func pressedICE() {
          self.slideMenuController()?.performSegue(withIdentifier: "showICESettings", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 

}
