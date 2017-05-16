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



class RemoteDatabase {
    
    static fileprivate var usersRef = FIRDatabase.database().reference().child("users")
    static fileprivate var restauarantsRef = FIRDatabase.database().reference().child("restaurants")
    
    /*
     TODO:
     - pull down information about restaurant based on the address
     - create a new restaurant
    */
    
    
    //USERS
    
    //Add a new user to the database, if you don't know their location, just put 0 and 0 for lat and lon
    static func addNewUser(_ username: String, firstName: String, lastName: String, locationLat: Double, locationLon: Double)
    {
        let newUser = ["first_name": firstName, "last_name": lastName, "location_lat": locationLat, "location_lon": locationLon, "photo_filename": ""] as [String : Any]
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
