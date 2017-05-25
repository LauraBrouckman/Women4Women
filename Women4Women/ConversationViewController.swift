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
    
    var recipientID: String!
    private var messages = [JSQMessage]()
    var conversationRef: FIRDatabaseReference?
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = UserDefaults.getUsername()
        self.senderDisplayName = UserDefaults.getFirstName()
        RemoteDatabase.m_delegate = self
        RemoteDatabase.getMessages(recipientID: self.recipientID)
        FIRDatabase.database().reference().child("users/"+UserDefaults.getUsername()+"/conversations/"+self.recipientID).observe(.value, with: { (snapshot) in
            RemoteDatabase.getMessages(recipientID: self.recipientID)
        })
        
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
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "ProfileImg"), diameter: 30)
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

}
