//
//  Note.swift
//  Project 19-21 Milestone
//
//  Created by Гнатюк Сергей on 30.05.2021.
//

import UIKit

class Note: Codable {
    var detail = ""
    var date = Date()
    var uuid = UUID().uuidString
}
