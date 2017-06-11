//
//  SettingsViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit
import Foundation


class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBOutlet weak var firstNameButton: UIButton!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var homeAddressButton: UIButton!
    @IBOutlet weak var homeAddressLabel2: UILabel!
    
    
    @IBAction func selectProfilePhoto(_ sender: Any)
    {
        var myPickerControllor = UIImagePickerController()
        myPickerControllor.delegate=self
        myPickerControllor.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerControllor, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        } else{
            print("Something went wrong")
        }
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let imageData = UIImagePNGRepresentation(image) {
                try? imageData.write(to: getImageUrl(imageFileName: "test"), options: [.atomic])
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameButton.layer.borderWidth = 1
        firstNameButton.layer.borderColor = UIColor.lightGray.cgColor
        homeAddressButton.layer.borderWidth = 1
        homeAddressButton.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameLabel.text = UserDefaults.getFirstName()
        lastNameLabel.text = UserDefaults.getLastName()
        homeAddressLabel.text = UserDefaults.getHomeStreet()
        homeAddressLabel2.text = UserDefaults.getHomeCity()
        
        
        let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let imagePath = libraryPath + "/Images"
        let filePath = imagePath + "/" + UserDefaults.getProfilePicFilename()

        let myURL = URL(fileURLWithPath: filePath)
        if let imageData = try? Data(contentsOf: myURL) {
            profilePic.image = UIImage(data: imageData)
        }
    }
    
    fileprivate func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    fileprivate func getImageUrl(imageFileName: String) -> URL {
        let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let imagePath = libraryPath + "/Images"
        let filePath = imagePath + "/" + imageFileName

        UserDefaults.setProfilePicFilename(imageFileName)
        return URL(fileURLWithPath: filePath)
    }
    


}
