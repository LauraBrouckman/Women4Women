//
//  RemoteDatabase.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/9/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import JSQMessagesViewController
extension Date {
    init(ticks: UInt64) {
        self.init(timeIntervalSince1970: Double(ticks)/10_000_000 - 62_135_596_800)
    }
}
protocol FetchData: class {
    func dataReceived(conversations: [Conversation])
}

protocol FetchMessages: class {
    func messageDataReceived(messages: [JSQMessage])
}

class RemoteDatabase {
    static weak var delegate: FetchData?
    static weak var m_delegate: FetchMessages?
    static let LAST_MESSAGE = "last_message"
    static fileprivate var usersRef = FIRDatabase.database().reference().child("users")
    static fileprivate var restauarantsRef = FIRDatabase.database().reference().child("restaurants")
    //var conversationsRef = usersRef.child(UserDefaults.getUsername()).child("conversations")
    
    /*
     TODO:
     - pull down information about restaurant based on the address
     - create a new restaurant
    */
    
    
    //USERS
    
    //Add a new user to the database, if you don't know their location, just put 0 and 0 for lat and lon
    static func addNewUser(_ username: String, password: String, firstName: String, lastName: String, locationLat: Double, locationLon: Double)
    {
        let newUser = ["password": password, "first_name": firstName, "last_name": lastName, "location_lat": locationLat, "location_lon": locationLon, "photo_filename": ""] as [String : Any]
        let newUserRef = usersRef.child(username)
        newUserRef.setValue(newUser)
        uploadFileToDatabase(forUser: username)
    }
    
    
    //Get a user from the database, pass in the username and a completion handler that will get called when the database returns with the answer to the query
    // If the answer is that that user does not exist, the handler will get called with the argument "nil"
    // Otherwise, it will get called with the argument being a dictionary of the user's information in the structure above
    static func getUserFromDB(_ username: String, completionHandler: @escaping (Any?) -> ()) {
        usersRef.child(username).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value is NSNull {
                completionHandler(nil)
            } else {
                completionHandler(snapshot.value)
            }
        })
    }
    
    
    // This function is called to update a users location in the database
    static func updateUserLocation(forUser username: String, locationLat: Double, locationLon: Double) {
        let currentUserRef = usersRef.child(username)
        let new_lat = ["location_lat": locationLat]
        let new_lon = ["location_lon": locationLon]
        currentUserRef.updateChildValues(new_lat)
        currentUserRef.updateChildValues(new_lon)
    }
    
    // This function is called to update a users name - not actually sure if this is useful
    static func updateUserName(forUser username: String, firstName: String, lastName: String) {
        let currentUserRef = usersRef.child(username)
        let new_first_name = ["first_name": firstName]
        let new_last_name = ["last_name": lastName]
        currentUserRef.updateChildValues(new_first_name)
        currentUserRef.updateChildValues(new_last_name)
    }
    
    // If the user ever changes their profile picture in settings, this function is called to change it
    static func updateProfilePicture(_ username: String) {
        uploadFileToDatabase(forUser: username)
    }
    
    static func sendMessage(to recipientID: String, messageToSend: Dictionary<String, Any>){
        // must update your side of the database.
        usersRef.child(UserDefaults.getUsername()).child("conversations").child(recipientID).child("last_message").setValue(messageToSend["text"])
        usersRef.child(UserDefaults.getUsername()).child("conversations").child(recipientID).childByAutoId().setValue(messageToSend)
        
        let sender = messageToSend["sender_id"] as! String
        usersRef.child(recipientID).child("conversations").child(sender).childByAutoId().setValue(messageToSend)
        usersRef.child(recipientID).child("conversations").child(sender).child("last_message").setValue(messageToSend["text"])
        // must update the person you just messaged.
        //let sender = messageToSend["sender_id"] as! String
        //if let recipientConversationsRef = usersRef.child(recipientID).child("conversations").child(sender){
        //    recipientConversationsRef.childByAutoID().setValue(messageToSend)
        //}
        
    }
    
    static func getMessages(recipientID: String){
        print("here")
        let messagesRef = usersRef.child(UserDefaults.getUsername()).child("conversations").child(recipientID)
        messagesRef.observeSingleEvent(of: FIRDataEventType.value){
            (snapshot: FIRDataSnapshot) in
            var messages = [JSQMessage]()
            print("made messages")
            if let myMessages = snapshot.value as? NSDictionary {
                for (key, value) in myMessages{
                    if key as! String !=  self.LAST_MESSAGE{
                        if let messageData = value as? NSDictionary{
                            let id = messageData["sender_id"] as! String
                            let name = messageData["sender_name"] as! String
                            let t =  messageData["text"] as! String
                            let d_str = messageData["date"] as! String
                            let d = Date(ticks: UInt64(NSString(string: d_str).doubleValue))
                            print(id)
                            print(name)
                            if let m = JSQMessage(senderId: id, senderDisplayName: name, date: d, text: t){
                                messages.append(m)
                            }
                        }
                    }
                }
            }
            messages = messages.sorted(by: { $0.date < $1.date })
            print("returning from getMessages")
            self.m_delegate?.messageDataReceived(messages: messages)
        }
    }
    
    static func getConversations(){
        let conversationRef = usersRef.child(UserDefaults.getUsername()).child("conversations")
        conversationRef.observeSingleEvent(of: FIRDataEventType.value){
            (snapshot: FIRDataSnapshot) in
            var conversations = [Conversation]()
            
            if let myConversations = snapshot.value as? NSDictionary {
                for (key, value) in myConversations{
                    if let conversationData = value as? NSDictionary{
                        
                        if let lastmessage=conversationData[self.LAST_MESSAGE] as? String{
                            let username = key as! String
                            let newConversation = Conversation(username: username, lastmessage: lastmessage)
                            conversations.append(newConversation)
                        }
                    }
                }
            }
            self.delegate?.dataReceived(conversations: conversations)
        }
    }
    

    
    
    
    
    // RESTAURANTS
    
    
    
    
    
    
    
    
    
    
    
    
    /*____________________________________________________________________________________________________________________________*/
    
   // Below are helper functions that are used to get from local storage a file called profile_pic.png and upload it under a random filename to the remote database
    
    static fileprivate func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    static fileprivate func randomStringWithLength (_ len : Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString
    }
    
    
    static fileprivate func uploadFileToDatabase(forUser username: String) {
        // The image file will be stored locally under the local directory as "profile_pic"
        let docDict = getDocumentsDirectory() as NSString
        let imagePath = docDict.appendingPathComponent("profile_pic.png")
        let fileURL = URL(fileURLWithPath: imagePath)
        
        let filename = randomStringWithLength(20) as String

        let storage = FIRStorage.storage()
        let gsReference = storage.reference(forURL: "gs://women4women-75e7d.appspot.com")
        let fileRef = gsReference.child(filename)
        
        let _ = fileRef.putFile(fileURL, metadata: nil) { metadata, error in
            if (error != nil) {
                print(error)
            } else {
                let currUserRef = self.usersRef.child(username)
                let newImage = ["photo_filename": filename]
                currUserRef.updateChildValues(newImage)
            }
        }
        
    }
    
    


    
    
    
}
