//
//  Conversation.swift
//  Women4Women
//
//  Created by chris lucas on 5/19/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import Foundation

class Conversation {
    private var _username=""
    private var _lastmessage=""
    
    init(username: String, lastmessage: String){
        _lastmessage = lastmessage
        _username = username
    }
    
    var username: String{
        return _username
    }
    
    var lastmessage: String{
        return _lastmessage
    }
}
