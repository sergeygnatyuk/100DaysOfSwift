//
//  CollisionTypes.swift
//  Project26
//
//  Created by Гнатюк Сергей on 09.06.2021.
//

import Foundation

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case transport = 32
}
