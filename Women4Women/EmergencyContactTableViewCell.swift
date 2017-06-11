//
//  EmergencyContactTableViewCell.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/20/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class EmergencyContactTableViewCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var emergencyContactLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let firstName = UserDefaults.getEmergencyContactFirstName()
        let lastName = UserDefaults.getEmergencyContactLastName()
        if firstName.isEmpty {
            emergencyContactLabel.text = "None"
        } else {
            emergencyContactLabel.text = firstName + " " + lastName
        }
        editButton.layer.cornerRadius = 6
        editButton.backgroundColor = UIColor.white
        editButton.setTitleColor(UIColor.black, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func updateEmergencyContact(_ sender: Any) {
//                let entityType = CNEntityType.contacts
//                let authStatus = CNContactStore.authorizationStatus(for: entityType)
//        
//                if authStatus == CNAuthorizationStatus.notDetermined{
//                    let contactStore = CNContactStore.init()
//                    contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
//                        if success {
//                            self.openContacts()
//                        }
//                        else {
//                            print("Not authorized")
//                        }
//                    })
//                }
//                else if authStatus == CNAuthorizationStatus.authorized {
//                    self.openContacts()
//                }
//        
    }

//    
//    func openContacts()
//    {
//        let contactPicker = CNContactPickerViewController.init()
//        contactPicker.delegate = self
//        self.present(contactPicker, animated: true, completion: nil)
//        
//    }
//    
//    func contactPickerDidCancel(_ picker: CNContactPickerViewController)
//    {
//        picker.dismiss(animated: true){
//            
//        }
//    }
//    
//    func contactPicker(_ picker:CNContactPickerViewController, didSelect contact: CNContact)
//    {
//        
//        UserDefaults.setEmergencyContactLastName(contact.familyName)
//        UserDefaults.setEmergencyContactFirstName(contact.givenName)
//        var phoneNo = "Not Avaliable"
//        
//        
//        let phoneString = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue"))
//        phoneNo = phoneString! as! String
//        
//        UserDefaults.setEmergencyContactPhoneNumber(phoneNo)
//    }
    


    


}
