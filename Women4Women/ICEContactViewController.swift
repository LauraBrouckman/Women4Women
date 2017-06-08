//
//  ICEContactViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/26/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ICEContactViewController: UIViewController, CNContactPickerDelegate {
    
    @IBOutlet weak var button: UIButton!

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameLabel.text = UserDefaults.getEmergencyContactFirstName()
        lastNameLabel.text = UserDefaults.getEmergencyContactLastName()
        phoneNumberLabel.text = UserDefaults.getEmergencyContactPhoneNumber()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateContact(_ sender: Any) {
        
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined{
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
                if success {
                    self.openContacts()
                }
                else {
                    print("Not authorized")
                }
            })
        }
        else if authStatus == CNAuthorizationStatus.authorized {
            self.openContacts()
        }
        
        
    }
    
    func openContacts()
    {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)

    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController)
    {
        picker.dismiss(animated: true){
            
        }
    }

    func contactPicker(_ picker:CNContactPickerViewController, didSelect contact: CNContact)
    {

        UserDefaults.setEmergencyContactLastName(contact.familyName)
        UserDefaults.setEmergencyContactFirstName(contact.givenName)
        var phoneNo = "Not Avaliable"

        
        let phoneString = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue"))
        phoneNo = phoneString! as! String
        
        UserDefaults.setEmergencyContactPhoneNumber(phoneNo)
    }

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exitICE" {
            if let vc = segue.destination as? ContainerViewController {
                vc.showSideMenu = true
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
