//
//  ConversationsTableViewController.swift
//  Women4Women
//
//  Created by chris lucas on 5/11/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import Firebase

class ConversationsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData {
    var senderDisplayName: String?
    let PALE_BLUE_HEX = "80AEF2"
    private let CELL_ID = "Cell"
    private let CHAT_SEGUE = "ChatSegue"
    private var cellFirstName = ""
    @IBOutlet weak var myMessages: UITableView!
    private var conversations = [Conversation]()
    
    //private lazy var conversationRef: FIRDatabaseReference=FIRDatabase.database().reference().child("conversations")
    //private var conversationRefHandle: FIRDatabaseHandle?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if conversations.count == 0{
            let noConversationsLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noConversationsLabel.text = "No messages to display."
            noConversationsLabel.textColor = UIColor.black
            noConversationsLabel.textAlignment = .center
            tableView.backgroundView = noConversationsLabel
            tableView.separatorStyle = .none
        }
        return conversations.count
    }

    func conversationFirstName(_ firstname: String){
        self.cellFirstName = firstname
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        let user = RemoteDatabase.getUserFromDB(conversations[indexPath.row].username) { user in
            if user == nil{
                print("error")
            }else{
                if let snapshotDict = user as? NSDictionary {
                    let firstname = snapshotDict["first_name"] as! String
                    let filename = snapshotDict["photo_filename"] as! String
                    cell.textLabel?.text = firstname
                    self.conversations[indexPath.row].firstname = firstname
                    self.conversations[indexPath.row].photofilename = filename
                }
            }
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        RemoteDatabase.delegate = self
        RemoteDatabase.getConversations()
        FIRDatabase.database().reference().child("users/"+UserDefaults.getUsername()+"/conversations").observe(.value, with: { (snapshot) in
            RemoteDatabase.getConversations()
        })
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        addNavBar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FIRDatabase.database().reference().child("users/"+UserDefaults.getUsername()+"/conversations").removeAllObservers()
    }
    
    func dataReceived(conversations: [Conversation]) {
        self.conversations = conversations
        myMessages.reloadData()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        senderDisplayName = conversations[indexPath.row].username
        performSegue(withIdentifier: CHAT_SEGUE, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CHAT_SEGUE{
            if let indexPath = self.myMessages.indexPathForSelectedRow {
                let controller = segue.destination as! ConversationViewController
                controller.recipientID = conversations[indexPath.row].username
                controller.userFirstName = conversations[indexPath.row].firstname
                controller.theirProfPic = conversations[indexPath.row].photofilename
                controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNavBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:54)) // Offset by 20 pixels vertically to take the status bar into account
        
        //navigationBar.barTintColor = UIColor.black
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = hexStringToUIColor(hex: PALE_BLUE_HEX)
        navigationBar.tintColor = UIColor.black
        
        //navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        
        let button: UIButton = UIButton(type: .custom)
        //set image for button
        button.setBackgroundImage(UIImage(named: "back_arrow.png"), for: UIControlState.normal)
        
        //add function for button
        button.addTarget(self, action: #selector(backBtn(_:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 15, height: 20)
        
        let backButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = backButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        navigationBar.topItem?.title = "Messages"
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1)
        )
    }
    
    
}
