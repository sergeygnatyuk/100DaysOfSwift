//
//  Person.swift
//  Project10
//
//  Created by Гнатюк Сергей on 25.04.2021.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
