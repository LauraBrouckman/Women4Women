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
    private let CELL_ID = "Cell"
    private let CHAT_SEGUE = "ChatSegue"
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].username
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        RemoteDatabase.delegate = self
        RemoteDatabase.getConversations()
        
        FIRDatabase.database().reference().child("users/"+UserDefaults.getUsername()+"/conversations").observe(.value, with: { (snapshot) in
            RemoteDatabase.getConversations()
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func dataReceived(conversations: [Conversation]) {
        self.conversations = conversations
        myMessages.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        senderDisplayName = conversations[indexPath.row].username
        performSegue(withIdentifier: CHAT_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CHAT_SEGUE{
            let vc = segue.destination as! ConversationViewController
            if let person = senderDisplayName{
                vc.recipientID = person
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
