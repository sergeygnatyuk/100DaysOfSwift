//
//  Capital.swift
//  Project16
//
//  Created by Гнатюк Сергей on 12.05.2021.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    // // project 16 challenge 3
    var wikipediaUrl: String
    
    init(title: String?, coordinate: CLLocationCoordinate2D, info: String, wikipediaUrl: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        // // project 16 challenge 3
        self.wikipediaUrl = wikipediaUrl
    }

}
