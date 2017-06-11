//
//  ConversationViewController.swift
//  Women4Women
//
//  Created by chris lucas on 5/19/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import MobileCoreServices
import AVKit

class ConversationViewController: JSQMessagesViewController, FetchMessages {
    
    let PALE_BLUE_HEX = "80AEF2"
    var userFirstName: String!
    var recipientID: String!
    var theirProfPic: String!
    
    var avatars = [String: JSQMessagesAvatarImage]()
    
    private var messages = [JSQMessage]()
    var conversationRef: FIRDatabaseReference?
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = UserDefaults.getUsername()
        self.senderDisplayName = UserDefaults.getFirstName()
        addAvatar("\(UserDefaults.getProfilePicFilename()).png", user: self.senderId)
        addAvatar(theirProfPic, user: self.recipientID)
        addNavBar()
        RemoteDatabase.m_delegate = self
        
        
        RemoteDatabase.getMessages(recipientID: self.recipientID)
        FIRDatabase.database().reference().child("users/"+UserDefaults.getUsername()+"/conversations/"+self.recipientID).observe(.value, with: { (snapshot) in
            RemoteDatabase.getMessages(recipientID: self.recipientID)
        })
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
    }

    func addAvatar(_ photoFileName: String, user username: String){
        print("in create avatars with:"+photoFileName+" for: "+username)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(photoFileName)").path
        print("fp:"+filePath)
        if FileManager.default.fileExists(atPath: filePath) {
            print("setting my prof pic")
            let av_img = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(contentsOfFile: filePath), diameter: 30)
            self.avatars[username] = av_img
        }else{
            self.avatars[username] = nil
        }
    }

    
    func addNavBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:54)) // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = hexStringToUIColor(hex: PALE_BLUE_HEX)
        navigationBar.tintColor = UIColor.black
        
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
        
        //let backButton =  UIBarButtonItem(title: "Back", style:   .plain, target: self, action: #selector(backBtn(_:)))
        //backButton.setImage(UIImage(named: "fb.png"), forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = backButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        navigationBar.topItem?.title = userFirstName
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FIRDatabase.database().reference().child("users/"+UserDefaults.getUsername()+"/conversations/"+self.recipientID).removeAllObservers()
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    // COLLECTION VIEW FUNCTIONS
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.row]
        if let av = avatars[message.senderId] {
            return av
        }else{
            return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "ProfileImg"), diameter: 30)
        }
        //return avatars[message.senderId]
        //return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "ProfileImg"), diameter: 30)
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    //override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        //let bubbleFactory = JSQMessagesBubbleImageFactory()
        //return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
    //}
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    func messageDataReceived(messages: [JSQMessage]){
        self.messages = messages
        self.collectionView?.reloadData()
    }
    
    //override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        //return cell
    //}
    
    // END COLLECTION VIEW FUNCTIONS
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        MessagesHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text, recipientID: recipientID)
        // removes text from text field.
        finishSendingMessage()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            alpha: CGFloat(0.5)
        )
    }

}
