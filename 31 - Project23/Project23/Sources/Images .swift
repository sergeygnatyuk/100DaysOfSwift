//
//  Images .swift
//  Project23
//
//  Created by Гнатюк Сергей on 03.06.2021.
//

import UIKit

enum Images {
    static let backgroundImage = "sliceBackground"
    static let lifeImage = "sliceLife"
    static let bombImage = "sliceBomb"
    static let penguinImage = "penguin"
    
    enum Font {
        static let fontChalkduster = "Chalkduster"
    }
    
    enum Sound {
        static let soundLaunch = "launch.caf"
        static let soundWhack = "whack.caf"
        static let soundExplosion = "explosion.caf"
        static let soundWrong = "wrong.caf"
    }
    
    enum Extension {
        static let enemyName = "enemy"
        static let bombContainerName = "bombContainer"
        static let bombName = "bomb"
        static let sliceBombFuse = "sliceBombFuse"
        static let extensionBombFuse = "caf"
        static let sliceFuse = "sliceFuse"
        static let sliceHitEnemy = "sliceHitEnemy"
        static let sliceHitBomb = "sliceHitBomb"
        static let sliceLifeGone = "sliceLifeGone"
    }
}

