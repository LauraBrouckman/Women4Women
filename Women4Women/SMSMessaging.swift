//
//  SMSMessaging.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/24/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation
import Alamofire

class SMSMessaging {

    
    static func sendSMSText() {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var timeToComeHome: String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        if let time = UserDefaults.getHomeTime() {
            timeToComeHome = dateFormatter.string(from: time)
        } else {
            let time = Date(timeIntervalSinceNow: TimeInterval(7200))
            timeToComeHome = dateFormatter.string(from: time)
        }
        
        let message = "Hi " + UserDefaults.getEmergencyContactFirstName() + "! " + " Your friend " + UserDefaults.getFirstName() + " has chosen you to be their emergency contact for the night.  Their plan is to go to " + UserDefaults.getNightOutLocationName() + " and to be home by " + timeToComeHome + ". We will keep you updated if their plan changes. Thanks for helping out!"
        
        let parameters: Parameters = [
            "To": UserDefaults.getEmergencyContactPhoneNumber(),
            "Body": message
        ]
        
        Alamofire.request("http://a566092e.ngrok.io/sms", method: .post, parameters: parameters, headers: headers).response { response in
            
        }
    }
    
    static func sendSOSText() {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let message = "Hi " + UserDefaults.getEmergencyContactFirstName() + "! " + " Your friend " + UserDefaults.getFirstName() + " has triggered an SOS.  This means that they feel very uncomfortable. People in their area have also been alerted, but please check in on your friend!"
        
        let parameters: Parameters = [
            "To": UserDefaults.getEmergencyContactPhoneNumber(),
            "Body": message
        ]
        
        Alamofire.request("http://a566092e.ngrok.io/sms", method: .post, parameters: parameters, headers: headers).response { response in
            
        }

    }
    
    static func sendHomeText() {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let message = "Hi " + UserDefaults.getEmergencyContactFirstName() + "! " + " Your friend " + UserDefaults.getFirstName() + " has arrived safely at home. Thanks for helping us out!"
        
        let parameters: Parameters = [
            "To": UserDefaults.getEmergencyContactPhoneNumber(),
            "Body": message
        ]
        
        Alamofire.request("http://a566092e.ngrok.io/sms", method: .post, parameters: parameters, headers: headers).response { response in
            
        }
    }

}
