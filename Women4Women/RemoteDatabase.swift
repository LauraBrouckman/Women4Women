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
    
    fileprivate var usersRef = FIRDatabase.database().reference().child("users")
    fileprivate var restauarantsRef = FIRDatabase.database().reference().child("restaurants")
    
}
