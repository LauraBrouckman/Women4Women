//
//  MessagesHandler.swift
//  Women4Women
//
//  Created by chris lucas on 5/19/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
class MessagesHandler {
    private static let _instance = MessagesHandler()
    private init(){}
    
    static var Instance: MessagesHandler{
        return _instance
    }
    
    func sendMessage(senderID: String, senderName: String, text: String, recipientID: String){
        let date_string = String(Date().ticks)
        let data: Dictionary<String, Any> = ["sender_id": senderID, "sender_name": senderName,"text": text, "date": date_string]
        RemoteDatabase.sendMessage(to: recipientID, messageToSend: data)
    }
}
