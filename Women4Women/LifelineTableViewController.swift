//
//  LifelineTableViewController.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import CoreData

class LifelineTableViewController: CoreDataTableViewController {
    private let MESSAGES_SEGUE = "ConversationsTableSegue"
    private let CHAT_SEGUE = "ConversationSegue"
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func openSettings(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    var sosDown = false
    var showSideMenu = false
    var counter = 5
    var timer = Timer()
    @IBOutlet weak var lifelineLabel: UILabel!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        updateUI()
        if showSideMenu {
            self.slideMenuController()?.openLeft()
        }
        
   
        
        // Add in custom SOS view
        let screenSize: CGRect = UIScreen.main.bounds
        var height: Double
        if screenSize.height - tableView.contentSize.height > 100 {
            height = Double(screenSize.height) - Double(tableView.contentSize.height)
        } else {
            height = 100
        }
        let customView = UIView(frame: CGRect(x: 0, y: 500, width: screenSize.width, height: CGFloat(height)))
        customView.backgroundColor = Colors.offWhite
        let x = (screenSize.width - 74) / 2
        let button = UIButton(frame: CGRect(x: x, y: 12, width: 74, height: 74))
        button.setTitle("SOS", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(Colors.red, for: .normal)
        button.layer.cornerRadius = 37
        button.layer.borderColor = Colors.red.cgColor
        button.layer.borderWidth = 10
        button.addTarget(self, action: #selector(sosRelease), for: .touchUpInside)
        button.addTarget(self, action: #selector(sosHold), for: .touchDown)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
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
    var countdownLabel: UILabel?
    fileprivate func addSOSOverlay() {
        let screenSize: CGRect = UIScreen.main.bounds
        let sosView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        sosView.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 77/255, blue: 77/255, alpha: 0.9)
        sosView.tag = 100
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let attrString = NSMutableAttributedString(string: "You are triggering the SOS feature. This will alert all nearby lifelines, your emergency contact, and your location that you need help.  Hold the button for 5 seconds to complete this action.")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: screenSize.width - 40, height: 600))
        label.numberOfLines = 10
        label.attributedText = attrString
        //label.text = "You are triggering the SOS feature. This will alert all nearby lifelines, your emergency contact, and your location that you need help.  Hold the button for 5 seconds to complete this action."
        label.textColor = UIColor.white
        label.font = label.font.withSize(20)
        sosView.addSubview(label)
        
        
        countdownLabel = UILabel(frame: CGRect(x: (screenSize.width - 70) / 2, y: 70, width: 70, height: 70))
        countdownLabel?.text = "5"
        countdownLabel?.textColor = UIColor.white
        countdownLabel?.font = label.font.withSize(80)
        sosView.addSubview(countdownLabel!)
        
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
            // SEND THE MESSAGES HERE
            SMSMessaging.sendSOSText()
            displayAlertMessage(alertMessage: "You have triggered an SOS. Your emergency contact, lifelines, and current location have been notified.")
            sosDown = false
        } else {
            print("they released the sos button not doin it")
        }
    }
    
    
    func displayAlertMessage(alertMessage:String) {
        let myAlert = UIAlertController(title:"Notice", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction)
        UIApplication.topViewController()?.present(myAlert, animated: true, completion: nil)
    }
    
    func timerAction() {
        counter -= 1
        if counter >= 0 {
            countdownLabel?.text = "\(counter)"
        }
        else {
            timer.invalidate()
        }
    }

    
    func sosHold() {
        // show overlay that explains what sos is
        timer.invalidate()
        addSOSOverlay()
        sosDown = true
        print("sos down")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.SOS()
        })
    }
    
    func sosRelease() {
        removeSOSOVerlay()
        timer.invalidate()
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
        if numLifelines == 0{
            lifelineLabel.text = "Oh no! There are no lifelines nearby"
        }
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
                    cell.photo_filename = photo_filename
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
    
    
     // MARK: - Navigation
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //senderDisplayName = conversations[indexPath.row].username
        performSegue(withIdentifier: CHAT_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == CHAT_SEGUE{
            let buttonPosition = (sender as AnyObject).convert(CGPoint(), to:tableView)
            let indexPath = tableView.indexPathForRow(at: buttonPosition)
            let controller = segue.destination as! ConversationViewController
            let cell = self.tableView.cellForRow(at: indexPath!) as! LifelineTableViewCell
            if let user = fetchedResultsController?.object(at: indexPath!) as? NearbyUser {
                controller.recipientID = user.username
                controller.userFirstName = user.first_name
            }
        } else if segue.identifier == "cancelNight" {
            UserDefaults.setNightOccuring(false)
            UserDefaults.setNightOutLocationName(name: "")
            UserDefaults.setNightOutLocation(latitude: 0, longitude: 0)
            UserDefaults.setHomeTime(nil)
        }
    }
    
 
    
}
