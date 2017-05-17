//
//  ConversationsTableViewController.swift
//  Women4Women
//
//  Created by chris lucas on 5/11/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import Firebase

enum Section: Int{
    case createNewConversationSection = 0
    case currentConversationsSection
}

// String id of conversation thread.
// unique id.
// name is sender name.
internal class Conversation{
    internal let id: String
    internal let name: String
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
}

class ConversationsTableViewController: UITableViewController {
    var senderDisplayName: String?
    //var newMessageTextField: UITextField?
    private var conversations: [Conversation]=[]
    // need to define some conversation class?
    // both parties, array of messages?
    
    private lazy var conversationRef: FIRDatabaseReference=FIRDatabase.database().reference().child("conversations")
    private var conversationRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Messages"
        observeConversations()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    deinit{
        if let refHandle = conversationRefHandle{
            conversationRef.removeObserver(withHandle: refHandle)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let currentSection:Section=Section(rawValue: section){
            switch currentSection {
            case .createNewConversationSection:
                return 1
            case .currentConversationsSection:
                return conversations.count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewConversationSection.rawValue ? "NewConversation" : "ExistingConversation"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if (indexPath as NSIndexPath).section==Section.createNewConversationSection.rawValue{
            print("hi")
            //}
            //if (indexPath as NSIndexPath).section == Section.createNewConversationSection.rawValue {
            
            //            if let createNewConversationCell = cell as? CreateConversationCell {
            //                newChannelTextField = createNewChannelCell.newChannelNameField
            //            }
            // creating new message here
        } else if (indexPath as NSIndexPath).section == Section.currentConversationsSection.rawValue {
            cell.textLabel?.text = conversations[(indexPath as NSIndexPath).row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.currentConversationsSection.rawValue {
            let conversation = conversations[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "ShowConversation", sender: conversation)
        }
    }
    
    //    1. You call observe:with: on your channel reference, storing a handle to the reference. This calls the completion block every time a new channel is added to your database.
    //    2. The completion receives a FIRDataSnapshot (stored in snapshot), which contains the data and other helpful methods.
    //    3. You pull the data out of the snapshot and, if successful, create a Channel model and add it to your channels array.
    private func observeConversations(){
        conversationRefHandle = conversationRef.observe(.childAdded, with: {(snapshot)->Void in // 1.
            let conversationData = snapshot.value as! Dictionary<String, AnyObject> // 2.
            let id = snapshot.key
            if let name = conversationData["name"] as! String!, name.characters.count>0{ // 3.
                self.conversations.append(Conversation(id: id, name: name))
                self.tableView.reloadData()
            }else{
                print("Error! Could not decode conversation data")
            }
        })
    }
    
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super .prepare(for: segue, sender: sender)
        if let conversation=sender as? Conversation {
            let chatVc = segue.destination as! ConversationViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.conversation = conversation
            chatVc.conversationRef = conversationRef.child(conversation.id)
        }
    }
    
    
}
