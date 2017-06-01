//
//  LifelineTableViewController.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import CoreData

class LifelineTableViewController: CoreDataTableViewController {
    private let MESSAGES_SEGUE = "ConversationsTableSegue"
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func openSettings(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    
    var sosDown = false
    var showSideMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        if showSideMenu {
            self.slideMenuController()?.openLeft()
        }
        
        let customView = UIView(frame: CGRect(x: 0, y: 500, width: 200, height: 80))
        let button = UIButton(frame: CGRect(x: 100, y: 12, width: 56, height: 56))
        button.setTitle("SOS", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(Colors.lightBlue, for: .normal)
        button.layer.cornerRadius = 28
        button.layer.borderColor = Colors.lightBlue.cgColor
        button.layer.borderWidth = 4
        button.addTarget(self, action: #selector(sosRelease), for: .touchUpInside)
        button.addTarget(self, action: #selector(sosHold), for: .touchDown)
        
        customView.addSubview(button)
        self.tableView.tableFooterView = customView
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // SOS Stuff
    fileprivate func addSOSOverlay() {
        let screenSize: CGRect = UIScreen.main.bounds
        print(screenSize.height)
        let sosView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        sosView.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 77/255, blue: 77/255, alpha: 0.9)
        sosView.tag = 100
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 250, height: 600))
        label.numberOfLines = 10
        label.text = "You are triggering the SOS feature. This will alert all nearby lifelines, your emergency contact, and the restaurant that you need help.  Hold the button for 5 seconds to complete this action."
        label.textColor = UIColor.white
        sosView.addSubview(label)
        // Add in a label possibly a countdown
        self.view.superview?.addSubview(sosView)
    }
    
    fileprivate func removeSOSOVerlay() {
        if let sosView = self.view.superview?.viewWithTag(100) {
            sosView.removeFromSuperview()
        }
    }
    
    
    fileprivate func SOS() {
        if(sosDown) {
            removeSOSOVerlay()
            // hide overlay
            // maybe have an alert that informs them that sos was triggered
            print("it's been 5 seconds, calling for SOS")
            sosDown = false
        } else {
            print("they released the sos button not doin it")
        }
    }
    
    
    func sosHold() {
        // show overlay that explains what sos is
        addSOSOverlay()
        sosDown = true
        print("sos down")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.SOS()
        })
    }
    
    func sosRelease() {
        removeSOSOVerlay()
        // hide overlay
        sosDown = false
        print("sos up")
    }
    
    private func updateUI() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NearbyUser")
        request.sortDescriptors = [NSSortDescriptor(key: "first_name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    //for some back button? write:
    //dismiss(animated: true, completion: nil)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let numLifelines = fetchedResultsController?.fetchedObjects?.count
        let row = indexPath.row
        
        if row < numLifelines! {
            let c = tableView.dequeueReusableCell(withIdentifier: "lifelineCell", for: indexPath)
            if let cell = c as? LifelineTableViewCell {
                
                if let user = fetchedResultsController?.object(at: indexPath) as? NearbyUser {
                    var first_name: String?
                    var last_name: String?
                    var photo_filename: String?
                    var username: String?
                    user.managedObjectContext?.performAndWait {
                        first_name = user.first_name
                        last_name = user.last_name
                        photo_filename = user.photo_filename
                        username = user.username
                    }
                    cell.lifelineNameLabel.text = first_name! + " " + last_name!
                    cell.username = username!
                    //SET THE PROFILE PICTURE IMAGE HERE!
                }
                return cell
                
            }
            return c
        }
        else if row == numLifelines {
            let c = tableView.dequeueReusableCell(withIdentifier: "nightOutCell", for: indexPath)
            return c
        }
        else if row == numLifelines! + 1 {
            let c = tableView.dequeueReusableCell(withIdentifier: "homeLocationCell", for: indexPath)
            return c
        }
        else if row == numLifelines! + 2 {
            let c = tableView.dequeueReusableCell(withIdentifier: "timePlanCell", for: indexPath)
            return c
        }
        else {
            let c = tableView.dequeueReusableCell(withIdentifier: "cancelNightCell", for: indexPath)
            return c
        }
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        if section == 0 {
    //            return "Lifelines"
    //        }
    //        return nil
    //    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
