//
//  UserDefaults.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/9/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation

// This file contains all the functions for getting and setting the user's information, so all of their settings (like emergency contact, time to be home) as well as stuff like their name and profile picture
// To use one of these functions:
// UserDefaults.setUsername("laura")
// let username = UserDefaults.getUsername()

class UserDefaults{
    
    //These are the keys for all the information about the user that is being stored locally
    static fileprivate var usernameKey              =   "usernameKey"
    static fileprivate var homeAlertOn              =   "homeAlertOnKey"
    static fileprivate var timeToBeHome             =   "timeHomeKey"
    static fileprivate var locationLatKey           =   "locationLatKey"
    static fileprivate var locationLonKey           =   "locationLonKey"
    static fileprivate var homeLocationLatKey       =   "homeLocationLatKey"
    static fileprivate var homeLocationLonKEy       =   "homeLocationLonKey"
    static fileprivate var firstNameKey             =   "firstNameKey"
    static fileprivate var lastNameKey              =   "lastNameKey"
    static fileprivate var emergencyContactNameKey  =   "emergencyContactNameKey"
    static fileprivate var emergencyContactNumKey   =   "emergencyContactNumKey"
    static fileprivate var profilePicFileKey        =   "profilePicFileKey"
    
    
    //Get and set the username for the user - this is the unique name that they use to log in
    static func setUsername(_ username: String) {
        Foundation.UserDefaults.standard.setValue(username, forKey: usernameKey)
    }
    
    static func getUsername() -> String {
        if let username = Foundation.UserDefaults.standard.value(forKey: usernameKey) as? String {
            return username
        }
        return ""
    }
    
    
    // Get and set whether or not the home alert feature is on
    static func setHomeAlert(on: Bool) {
        Foundation.UserDefaults.standard.set(on, forKey: homeAlertOn)
    }
    
    static func getHomeAlert() -> Bool {
        if let homeAlert = Foundation.UserDefaults.standard.value(forKey: homeAlertOn) as? Bool {
            return homeAlert
        }
        return true
    }
    
    // Get and set the time that the user wants to be home by
    static func setHomeTime(_ time: NSDate) {
        Foundation.UserDefaults.standard.setValue(time, forKey: timeToBeHome)
    }
    
    static func getHomeTime() -> NSDate? {
        if let time = Foundation.UserDefaults.standard.value(forKey: timeToBeHome) as? NSDate {
            return time
        }
        return nil
    }
    
    //Get the night out location (set by passing in the latitude and longitude coordinates as Doubles
    static func setNightOutLocation(latitude: Double, longitude: Double) {
        Foundation.UserDefaults.standard.setValue(latitude, forKey: locationLatKey)
        Foundation.UserDefaults.standard.setValue(longitude, forKey: locationLonKey)
    }
    
    static func getNightOutLocation() -> (Double, Double)? {
        if let latitude = Foundation.UserDefaults.standard.value(forKey: locationLatKey) as? Double {
            if let longitude = Foundation.UserDefaults.standard.value(forKey: locationLonKey) as? Double {
                return (latitude, longitude)
            }
        }
        return nil
    }
    
    //Get and set the home location (set by passing in the latitude and longitude coordinates as Doubles)
    // Google how to convert address to lat/lon if needed
    static func setHomeLocation(latitude: Double, longitude: Double) {
        Foundation.UserDefaults.standard.setValue(latitude, forKey: homeLocationLatKey)
        Foundation.UserDefaults.standard.setValue(longitude, forKey: homeLocationLonKEy)
    }
    
    static func getHomeLocation() -> (Double, Double)? {
        if let latitude = Foundation.UserDefaults.standard.value(forKey: homeLocationLatKey) as? Double {
            if let longitude = Foundation.UserDefaults.standard.value(forKey: homeLocationLonKEy) as? Double {
                return (latitude, longitude)
            }
        }
        return nil
    }
    
    
    //Get the users first name 
    static func setFirstName(_ first: String) {
        Foundation.UserDefaults.standard.setValue(first, forKey: firstNameKey)
    }
    
    static func getFirstName() -> String {
        if let first = Foundation.UserDefaults.standard.value(forKey: firstNameKey) as? String {
            return first
        }
        return ""
    }

    //Get and set the last name
    static func setLastName(_ last: String) {
        Foundation.UserDefaults.standard.setValue(last, forKey: lastNameKey)
    }
    
    static func getLastName() -> String {
        if let last = Foundation.UserDefaults.standard.value(forKey: lastNameKey) as? String {
            return last
        }
        return ""
    }

    //Get and set the full name of the emergency contact
    static func setEmergencyContactName(_ name: String) {
        Foundation.UserDefaults.standard.setValue(name, forKey: emergencyContactNameKey)
    }
    
    static func getEmergencyContactName() -> String {
        if let name = Foundation.UserDefaults.standard.value(forKey: emergencyContactNameKey) as? String {
            return name
        }
        return ""
    }

    //Get and set the emergency contact phone number : IMPORTANT: phone numbers will be stored and retrieved as a string (like "7038563725") with JUST numbers (no spaces, (), -)
    
    static func setEmergencyContactPhoneNumber(_ number: String) {
        Foundation.UserDefaults.standard.setValue(number, forKey: emergencyContactNumKey)
    }
    
    static func getEmergencyContactPhoneNumber() -> String {
        if let number = Foundation.UserDefaults.standard.value(forKey: emergencyContactNumKey) as? String {
            return number
        }
        return ""
    }
    
    static func setProfilePicFilename(_ filename: String) {
        Foundation.UserDefaults.standard.setValue(filename, forKey: profilePicFileKey)
    }
    
    static func getProfilePicFilename() -> String {
        if let filename = Foundation.UserDefaults.standard.value(forKey: profilePicFileKey) as? String {
            return filename
        }
        return ""
    }

}
