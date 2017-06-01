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
        
        //let url = info[UIImagePickerControllerReferenceURL] as! URL
       // let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
        //let fileName = PHAssetResource.assetResources(for: assets.firstObject!).first!.originalFilename
        
        if let image = profilePic.image {
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
        
        //profilePic.imageFromUrl(getImageUrl(imageFileName: UserDefaults.getProfilePicFilename()))
        
        
        let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let imagePath = libraryPath + "/Images"
        let filePath = imagePath + "/" + UserDefaults.getProfilePicFilename()
        let fileManager = FileManager.default
//        do {
//            try fileManager.createDirectory(atPath: imagePath, withIntermediateDirectories: false, attributes: nil)
//        } catch let error1 as NSError {
//            print("error" + error1.description)
//        }
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
        let docDict = getDocumentsDirectory() as NSString
        let imagePath = docDict.appendingPathComponent(imageFileName)
        UserDefaults.setProfilePicFilename(imageFileName)
        print(imagePath)
        return URL(fileURLWithPath: imagePath)
    }
    


}
