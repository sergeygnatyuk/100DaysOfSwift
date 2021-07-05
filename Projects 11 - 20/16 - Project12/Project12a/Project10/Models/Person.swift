//
//  Person.swift
//  Project10
//
//  Created by Гнатюк Сергей on 25.04.2021.
//

import UIKit

final class Person: NSObject, NSCoding {
    
    //Properties
    private let nameKey = "name"
    private let imageKey = "image"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(image, forKey: imageKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    public var name: String
    public var image: String
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
