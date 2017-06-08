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
        let myPickerControllor = UIImagePickerController()
        myPickerControllor.delegate = self
        myPickerControllor.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerControllor, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let imageData = UIImagePNGRepresentation(image) {
                do {
                    try imageData.write(to: getImageUrl(imageFileName: "test"), options: [.atomic])
                    // upload image to remote DB
                    RemoteDatabase.updateProfilePicture(UserDefaults.getUsername())
                } catch  {
                    print("something went wrong while writing")
            }
            }
        }
        else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameButton.layer.borderWidth = 1
        firstNameButton.layer.borderColor = UIColor.lightGray.cgColor
        homeAddressButton.layer.borderWidth = 1
        homeAddressButton.layer.borderColor = UIColor.lightGray.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
        profilePic.clipsToBounds = true
        
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
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(UserDefaults.getProfilePicFilename()).png").path
        if FileManager.default.fileExists(atPath: filePath) {
             profilePic.image = UIImage(contentsOfFile: filePath)
        }
    }
    
    
    fileprivate func getImageUrl(imageFileName: String) -> URL {
        UserDefaults.setProfilePicFilename(imageFileName)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("\(imageFileName).png")
        return fileURL
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exitSettings" {
            if let vc = segue.destination as? ContainerViewController {
                vc.showSideMenu = true
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    


}
