//
//  GameState.swift
//  Project5
//
//  Created by Гнатюк Сергей on 02.05.2021.
//

import Foundation

// project 12 challenge 3
struct GameState: Codable {
    var currentWord: String
    var usedWords: [String]
}
