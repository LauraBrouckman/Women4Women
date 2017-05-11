//
//  NearbyUser+CoreDataClass.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation
import CoreData

@objc(NearbyUser)
public class NearbyUser: NSManagedObject {
// want to be able to: get all the users from the list
// get a specific user by username
//delete all current nearby users and update the whole list

    
    
    // Returns all the nearby users
    class func getAllNearbyUsers(inManagedObjectContext context: NSManagedObjectContext) -> [NearbyUser]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NearbyUser")
        if let result = (try? context.fetch(request)) as? [NearbyUser] {
            return result
        }
        return nil
    }
    
    //Given a list of nearby users, makes this the new list of users in the database
    class func setNearbyUsers(nearbyUsers: [[String: Any]], inManagedObjectContext context: NSManagedObjectContext) {
        //remove all the old users
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NearbyUser")
            if let results = (try? context.fetch(fetchRequest)) as? [NearbyUser] {
                for managedObject in results {
                    let managedObjectData:NSManagedObject = managedObject as NSManagedObject
                    context.delete(managedObjectData)
                }
            }
        //add in new users
        for user in nearbyUsers {
            if let result = NSEntityDescription.insertNewObject(forEntityName: "NearbyUser", into: context) as? NearbyUser {
                print("adding \(user)")
                
                result.username = user["username"] as? String
                result.last_name = user["last_name"] as? String
                result.first_name = user["first_name"] as? String
                result.latitude = user["latitude"] as! Double
                result.longitude = user["longitude"] as! Double
                result.photo_filename = user["photo_filename"] as? String
            }
        }
    }
    
    
    // Get the information for a single nearby user by their username
    class func getNearbyUser(withUsername username: String, inManagedObjectContext context: NSManagedObjectContext) -> NearbyUser? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NearbyUser")
        request.predicate = NSPredicate(format: "username = %@", username)
        
        /*If the article already is in the database then just return the article object */
        if let result = (try? context.fetch(request))?.first as? NearbyUser {
            return result

        }
        return nil
    }
    
}
