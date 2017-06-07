//
//  UserDefaults.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/9/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation
import MapKit

// This file contains all the functions for getting and setting the user's information, so all of their settings (like emergency contact, time to be home) as well as stuff like their name and profile picture
// To use one of these functions: 
// UserDefaults.setUsername("laura")
// let username = UserDefaults.getUsername()

class UserDefaults{
    
    //These are the keys for all the information about the user that is being stored locally
    static fileprivate var openedBefore             = "openedBefore"
    static fileprivate var loggedIn                 = "loggedIn"
    static fileprivate var passwordKey              =   "passwordKey"
    static fileprivate var usernameKey              =   "usernameKey"
    static fileprivate var homeAlertOn              =   "homeAlertOnKey"
    static fileprivate var timeToBeHome             =   "timeHomeKey"
    static fileprivate var locationLatKey           =   "locationLatKey"
    static fileprivate var locationLonKey           =   "locationLonKey"
    static fileprivate var homeLocationLatKey       =   "homeLocationLatKey"
    static fileprivate var homeLocationLonKEy       =   "homeLocationLonKey"
    static fileprivate var firstNameKey             =   "firstNameKey"
    static fileprivate var lastNameKey              =   "lastNameKey"
    static fileprivate var emergencyContactFirstNameKey  =   "emergencyContactFirstNameKey"
    static fileprivate var emergencyContactLastNameKey  =   "emergencyContactLastNameKey"
    static fileprivate var emergencyContactNumKey   =   "emergencyContactNumKey"
    static fileprivate var profilePicFileKey        =   "profilePicFileKey"
    static fileprivate var homeCityKey             =   "homeCityKey"
    static fileprivate var homeStreetKey             =   "homeStreetKey"
    static fileprivate var homeZipKey             =   "homeZipKey"
    static fileprivate var homeCountryKey             =   "homeCountryKey"
    static fileprivate var homeLocationNameKey             =   "homeLocationNameKey"
    static fileprivate var nightOutLocationKey = "nightOutLocationKey"
    static fileprivate var iceFirstNameKey             =   "iceFirstNameKey"
    static fileprivate var iceLastNameKey             =   "iceLastNameKey"
    static fileprivate var icePhoneNumberKey             =   "icePhoneNumberKey"
    static fileprivate var homeStateKey             =   "homeStateKey"
    static fileprivate var nightOccuringKey         = "nightOccuringKey"
    //Get and set if user logged in
    
    static func setNightOccuring(_ on: Bool) {
        Foundation.UserDefaults.standard.set(on, forKey: nightOccuringKey)
    }
    
    static func getNightOccuring() -> Bool {
        if let value = Foundation.UserDefaults.standard.value(forKey: nightOccuringKey) as? Bool {
            return value
        }
        return false
    }
    
    static func setLoggedIn(on: Bool){
        Foundation.UserDefaults.standard.set(on, forKey: loggedIn);
    }
    
    static func getLoggedIn() -> Bool{
        return Foundation.UserDefaults.standard.bool(forKey: loggedIn);
    }
    
    
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
    
    //Get and set the password for the user - this is the unique password that they use to log in
    static func setPassword(_ password: String) {
        Foundation.UserDefaults.standard.setValue(password, forKey: passwordKey)
    }
    
    static func getPassword() -> String {
        if let password = Foundation.UserDefaults.standard.value(forKey: passwordKey) as? String {
            return password
        }
        return ""
    }
    
    // Get and set whether the app has been opened before
    static func setAppOpenedBefore(_ value: Bool) {
        Foundation.UserDefaults.standard.set(value, forKey: openedBefore)
    }
    
    static func getAppOpenedBefore() -> Bool {
        if let opened = Foundation.UserDefaults.standard.value(forKey: openedBefore) as? Bool {
            return opened
        }
        return false
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
    static func setHomeTime(_ time: Date) {
        Foundation.UserDefaults.standard.setValue(time, forKey: timeToBeHome)
    }
    
    static func getHomeTime() -> Date? {
        if let time = Foundation.UserDefaults.standard.value(forKey: timeToBeHome) as? Date {
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
    
    static func setNightOutLocationName(name: String) {
        Foundation.UserDefaults.standard.setValue(name, forKey: nightOutLocationKey)
    }
    
    static func getNightOutLocationName() -> String {
        if let name = Foundation.UserDefaults.standard.value(forKey: nightOutLocationKey) as? String {
            return name
        }
        return ""
    }
    
    //Get and set the home location (set by passing in the latitude and longitude coordinates as Doubles)
    // Google how to convert address to lat/lon if needed
    static func setHomeLocation(latitude: Double, longitude: Double) {
        Foundation.UserDefaults.standard.setValue(latitude, forKey: homeLocationLatKey)
        Foundation.UserDefaults.standard.setValue(longitude, forKey: homeLocationLonKEy)
        //UserDefaults.getAddressNameFromCoordinates(lat: latitude, long: longitude)
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
    
    //Get and set the first name of the emergency contact
    static func setEmergencyContactFirstName(_ first: String) {
        Foundation.UserDefaults.standard.setValue(first, forKey: emergencyContactFirstNameKey)
    }
    
    static func getEmergencyContactFirstName() -> String {
        if let first = Foundation.UserDefaults.standard.value(forKey: emergencyContactFirstNameKey) as? String {
            return first
        }
        return ""
    }
    
    //Get and set the last name of the emergency contact
    static func setEmergencyContactLastName(_ last: String) {
        Foundation.UserDefaults.standard.setValue(last, forKey: emergencyContactLastNameKey)
    }
    
    static func getEmergencyContactLastName() -> String {
        if let last = Foundation.UserDefaults.standard.value(forKey: emergencyContactLastNameKey) as? String {
            return last
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
        return "profile_pic"
    }
    
    //Get and set home city
    static func setHomeCity(_ city: String) {
        Foundation.UserDefaults.standard.setValue(city, forKey: homeCityKey)
    }
    
    static func getHomeCity() -> String {
        if let city = Foundation.UserDefaults.standard.value(forKey: homeCityKey) as? String {
            return city
        }
        return ""
    }
    
    static func setHomeStreet(_ street: String) {
        Foundation.UserDefaults.standard.setValue(street, forKey: homeStreetKey)
    }
    
    static func getHomeStreet() -> String {
        if let street = Foundation.UserDefaults.standard.value(forKey: homeStreetKey) as? String {
            return street
        }
        return ""
    }
    
    //Get and set home street
    static func setHomeState(_ state: String) {
        Foundation.UserDefaults.standard.setValue(state, forKey: homeStateKey)
    }
    
    static func getHomeState() -> String {
        if let state = Foundation.UserDefaults.standard.value(forKey: homeStateKey) as? String {
            return state
        }
        return ""
    }
    
    //Get and set home zip
    static func setHomeZip(_ zip: String) {
        Foundation.UserDefaults.standard.setValue(zip, forKey: homeZipKey)
    }
    
    static func getHomeZip() -> String {
        if let zip = Foundation.UserDefaults.standard.value(forKey: homeZipKey) as? String {
            return zip
        }
        return ""
    }
    
    //Get and set home country
    static func setHomeCountry(_ country: String) {
        Foundation.UserDefaults.standard.setValue(country, forKey: homeCountryKey)
    }
    
    static func getHomeCountry() -> String {
        if let country = Foundation.UserDefaults.standard.value(forKey: homeCountryKey) as? String {
            return country
        }
        return ""
    }
    
    //Get and set home location name
    static func setHomeLocationName(_ locationName: String) {
        Foundation.UserDefaults.standard.setValue(locationName, forKey: homeLocationNameKey)
    }
    
    static func getHomeLocationName() -> String {
        if let locationName = Foundation.UserDefaults.standard.value(forKey: homeLocationNameKey ) as? String {
            return locationName
        }
        return ""
    }

    static func getAddressNameFromCoordinates(_ callback: (() -> Void)?)
    {
        let geoCoder = CLGeocoder()
        let (lat, lon) = UserDefaults.getHomeLocation()!
        let location = CLLocation(latitude: lat, longitude: lon)

        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
                        // Location name
            if let locationName = placeMark.addressDictionary?["Name"] as? NSString
            {
                UserDefaults.setHomeLocationName(String(locationName))
            }
            
            // Street address
            if let street = placeMark.addressDictionary?["Street"] as? NSString
            {
                UserDefaults.setHomeStreet(String(street))
            }
            
            // City
            if let city = placeMark.addressDictionary?["City"] as? NSString
            {
                UserDefaults.setHomeCity(String(city))
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary?["ZIP"] as? NSString
            {
                UserDefaults.setHomeZip(String(zip))
            }
            
            // Country
            if let country = placeMark.addressDictionary?["Country"] as? NSString
            {
                UserDefaults.setHomeCountry(String(country))
            }
            callback?()
        }
    }
    
    static func getCoordinatesFromAddressName(address: String?, title: String?){
        var ad = address
        if address == nil {
            //error no address
            ad = title
        }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(ad!) {
            if let placemarks = $0 {
                let coordinate = (placemarks[0].location?.coordinate)!
                UserDefaults.setHomeLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
            } else {
                print("error \($1)")
            }
        }
    }
    
}
