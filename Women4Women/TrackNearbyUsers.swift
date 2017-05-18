//
//  TrackNearbyUsers.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation
import CoreData
import Firebase


class TrackUsers {
    static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var distanceThreshold: Double = 0.0018 //how far apart max two users can be in degrees
    
    static func updateNearbyUserList(users: [String: AnyObject]) {
        
        // Really should get the users location from local storage
        let (myLatitude, myLongitude) = UserDefaults.getNightOutLocation() ?? (37.422692, -122.168603)        
        
        var nearbyUsers: [[String: Any]] = []
        
        //Look through each user in the list and calculate the distance apart, if the distance is short, add to array of nearby users
        for user in users {
            // Don't add yourself to the list
            if user.key == UserDefaults.getUsername() {
                continue
            }
            
            let username = user.key
            let userData = user.value
            let userLatitude = userData["location_lat"] as! Double
            let userLongitude = userData["location_lon"] as! Double
            let distance = sqrt(pow(userLatitude - myLatitude, 2.0) + pow(userLongitude - myLongitude, 2.0))

            if distance <= distanceThreshold {
                let newUser: [String: Any] = [
                    "username": username,
                    "longitude": userLongitude,
                    "latitude": userLatitude,
                    "photo_filename": userData["photo_filename"] as? String ?? "",
                    "first_name": userData["first_name"] as? String ?? "",
                    "last_name": userData["last_name"] as? String ?? "",
                    "home_city": userData["home_city"] as? String ?? ""
                ]
                nearbyUsers.append(newUser)
                //Add user to list of nearby users
            }
        }        
        
        // Add the nearby users to the list in CoreData
        self.managedObjectContext.perform {
            NearbyUser.setNearbyUsers(nearbyUsers: nearbyUsers, inManagedObjectContext: self.managedObjectContext)
            do {
                try managedObjectContext.save()
                
            } catch let error {
                print(error)
            }
        }
    
    }


}
