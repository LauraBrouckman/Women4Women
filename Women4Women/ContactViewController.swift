//
//  ContactViewController.swift
//  Women4Women
//
//  Created by Leslie Kurt on 5/30/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import Contacts

class ContactViewController: UITableViewController  {
    
    
    fileprivate var contacts: [CNContact]? {
        didSet {
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        getContacts()
    }
    
    
    fileprivate func getContacts() {
        let store = CNContactStore()
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts) { (authorized: Bool, error: Error?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store)
                }
            }
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store)
        }
    }
    
    fileprivate func retrieveContactsWithStore(_ store: CNContactStore) {
        do {
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey, CNContactImageDataKey] as [Any]
            let containerId = CNContactStore().defaultContainerIdentifier()
            let predicate: NSPredicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
            let contacts = try CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            self.contacts = contacts
        } catch {
            print(error)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Should be 2
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contacts == nil {
            return UITableViewCell()
        }
        var cell = UITableViewCell()
        var contact = contacts![indexPath.row]
        cell.textLabel?.text = contact.givenName + " " + contact.familyName
        return cell
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.performSegue(withIdentifier: "cancelICE", sender: sender)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func extractNumber(_ phoneNumber: String) -> String {
        var num = ""
        for character in phoneNumber.characters {
            let value = Int(String(character))
            if value != nil {
                num.append(character)
            }
        }
        if num[num.startIndex] == "1" {
            num = String(num.characters.dropFirst())
        }
        return num
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "changeICE", sender: tableView.cellForRow(at: indexPath))
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            print(identifier)
            if identifier == "cancelICE" {
                if let containerVC = segue.destination as? ContainerViewController {
                    containerVC.hidePopup = false
                }
            }
            else if identifier == "changeICE"{
                if let cell = sender as? UITableViewCell {
                    if let indexPath = tableView.indexPath(for: cell) {
                        if let containerVC = segue.destination as? ContainerViewController {
                            
                            containerVC.hidePopup = false
                            if contacts != nil {
                                let contact = contacts![indexPath.row]
                                
                                UserDefaults.setEmergencyContactFirstName(contact.givenName)
                                UserDefaults.setEmergencyContactLastName(contact.familyName)
                                UserDefaults.setEmergencyContactPhoneNumber(extractNumber(contact.phoneNumbers[0].value.stringValue))
                            }
                        }
                    }
                }
            }
        }
    }
    
}
