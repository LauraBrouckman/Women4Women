//
//  UserAnnotation.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/16/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit
class UserAnnotation: NSObject, MKAnnotation{
    var identifier = "user annotation"
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var filename: String?
    init(name:String, center: CLLocationCoordinate2D, sub: String?, photo_filename: String?){
        title = name
        coordinate = center
        filename = photo_filename
        //subtitle = sub
    }
}
