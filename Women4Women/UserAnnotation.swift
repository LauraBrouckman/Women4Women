//
//  UserAnnotation.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/16/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit
class UserAnnotation: NSObject, MKAnnotation{
    var identifier = "user annotation"
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    init(name:String, center: CLLocationCoordinate2D, sub: String?){
        title = name
        coordinate = center
        //subtitle = sub
    }
}
