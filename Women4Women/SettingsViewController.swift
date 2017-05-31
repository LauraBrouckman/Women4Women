//
//  SettingsViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBOutlet weak var firstNameButton: UIButton!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var homeAddressButton: UIButton!
    @IBOutlet weak var homeAddressLabel2: UILabel!

//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//            let imageURL = info[UIImagePickerControllerReferenceURL] as NSURL
//            let imageName = imageURL.path!.lastPathComponent
//            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String
//            let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
//        
//            let image = info[UIImagePickerControllerOriginalImage] as UIImage
//            let data = UIImagePNGRepresentation(image)
//            data.writeToFile(localPath, atomically: true)
//        
//            let imageData = NSData(contentsOfFile: localPath)!
//            let photoURL = NSURL(fileURLWithPath: localPath)
//            let imageWithData = UIImage(data: imageData)!
//        
//            picker.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
    
    
    @IBAction func selectProfilePhoto(_ sender: Any)
    {
        var myPickerControllor = UIImagePickerController()
        myPickerControllor.delegate=self
        myPickerControllor.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerControllor, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        profilePic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
       
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
