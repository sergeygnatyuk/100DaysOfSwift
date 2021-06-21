//
//  GameScene+SKPhysicsContactDelegate.swift
//  Project29
//
//  Created by Гнатюк Сергей on 20.06.2021.
//

import SpriteKit
import GameplayKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        if firstNode.name == bananaName && secondNode.name == buildingName {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        if firstNode.name == bananaName && secondNode.name == player1Name {
            destroy(player: player2)
        }
        if firstNode.name == bananaName && secondNode.name == player2Name {
            destroy(player: player1)
        }
    }
}
