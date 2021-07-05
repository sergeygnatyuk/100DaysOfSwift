//
//  Country.swift
//  Project 13-15 Milestone
//
//  Created by Гнатюк Сергей on 11.05.2021.
//

import UIKit

struct Country: Codable {
    let currencies: [Currency]
    let languages: [Language]
    let flag: String
    let name, alpha2Code, capital: String
    let population: Int
    let demonym: String
    let area: Double?
    let nativeName: String
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}

struct Language: Codable {
    let iso639_1: String?
    let iso639_2: String
    let name: String
    let nativeName: String
}

enum CodingKeys: String, CodingKey {
    case iso6391 = "iso639_1"
    case iso6392 = "iso639_2"
    case name, nativeName
}

typealias Countries = [Country]
