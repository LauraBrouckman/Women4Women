//
//  NearbyUser+CoreDataProperties.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation
import CoreData


extension NearbyUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NearbyUser> {
        return NSFetchRequest<NearbyUser>(entityName: "NearbyUser");
    }

    @NSManaged public var username: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var photo_filename: String?
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?

}
