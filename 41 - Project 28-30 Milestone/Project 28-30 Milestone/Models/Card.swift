//
//  Card.swift
//  Project 28-30 Milestone
//
//  Created by Гнатюк Сергей on 25.06.2021.
//

import Foundation

struct Card {
    internal init() {
        self.identifier = Card.identifierGenerator()
    }
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    static var identifierNumber = 0
    static func identifierGenerator() -> Int {
        identifierNumber += 1
        return identifierNumber
    }
}
