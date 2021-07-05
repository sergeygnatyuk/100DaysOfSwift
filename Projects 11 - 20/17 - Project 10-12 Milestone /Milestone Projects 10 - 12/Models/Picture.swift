//
//  Picture.swift
//  Milestone Projects 10 - 12
//
//  Created by Гнатюк Сергей on 02.05.2021.
//

import Foundation

class Picture: Codable {
    var imageName: String
    var image: String
    
    init(imageName: String, image: String) {
        self.imageName = imageName
        self.image = image
    }
}
