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
        nameLabel.text = UserDefaults.getFirstName()+" "+UserDefaults.getLastName()
        //logoutButton.
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let imagePath = libraryPath + "/Images"
        let filePath = imagePath + "/" + UserDefaults.getProfilePicFilename()
        
        let myURL = URL(fileURLWithPath: filePath)
        if let imageData = try? Data(contentsOf: myURL) {
            profileThumbnail.image = UIImage(data: imageData)
        }
    }
    

    @IBAction func logoutUser(_ sender: Any) {
        UserDefaults.setLoggedIn(on: false);
        UserDefaults.setNightOccuring(false)
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
