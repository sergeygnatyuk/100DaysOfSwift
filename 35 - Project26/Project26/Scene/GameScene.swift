//
//  GameScene.swift
//  Project26
//
//  Created by Гнатюк Сергей on 08.06.2021.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: FileNameModel.background)
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        loadLevel()
    }
    
    private func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: FileNameModel.level1, withExtension: FileNameModel.extensionTxt) else {
            fatalError("Could not find level1.txt in the app bundle")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle")
        }
        let lines = levelString.components(separatedBy: FileNameModel.separator)
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                if letter == "x" {
                    let node = SKSpriteNode(imageNamed: FileNameModel.block)
                    node.position = position
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic = false
                    addChild(node)
                } else if letter == "v" {
                    let node = SKSpriteNode(imageNamed: FileNameModel.vortex)
                    node.name = FileNameModel.vortex
                    node.position = position
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    addChild(node)
                } else if letter == "s" {
                    let node = SKSpriteNode(imageNamed: FileNameModel.star)
                    node.name = FileNameModel.star
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    node.position = position
                    addChild(node)
                } else if letter == "f" {
                    let node = SKSpriteNode(imageNamed: FileNameModel.finish)
                    node.name = FileNameModel.finish
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    node.position = position
                    addChild(node)
                } else if letter == " " {
                    
                } else {
                    fatalError("Unknown level letter \(letter)")
                }
            }
        }
    }
}
