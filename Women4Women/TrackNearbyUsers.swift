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
    static var distanceThreshold: Double = 0.001 //how far apart max two users can be in degrees
    
    static func updateNearbyUserList(users: [String: AnyObject]) {
        let myLatitude = 37.422692
        let myLongitude = -122.168603
        
        // Really should get the users location from local storage
        //let (myLatitude, myLongitude) = UserDefaults.getNightOutLocation()!
        
        var nearbyUsers: [[String: Any]] = []
        
        //Look through each user in the list and calculate the distance apart, if the distance is short, add to array of nearby users
        for user in users {
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
                    "last_name": userData["last_name"] as? String ?? ""
                ]
                nearbyUsers.append(newUser)
                //Add user to list of nearby users
            }
        }
        print("Nearby users are: \(nearbyUsers)" )
        
        
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
