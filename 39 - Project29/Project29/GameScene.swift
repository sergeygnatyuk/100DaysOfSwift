//
//  GameScene.swift
//  Project29
//
//  Created by Гнатюк Сергей on 19.06.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Properties
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController?
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    var currentPlayer = 1
    let playerName = "player"
    let player1Name = "player1"
    let player2Name = "player2"
    let bananaName = "banana"
    let player1Throw = "player1Throw"
    let player2Throw = "player2Throw"
    let buildingName = "building"
    let hitPlayer = "hitPlayer"
    let hitBuilding = "hitBuilding"
    
    // MARK: - View
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
        physicsWorld.contactDelegate = self
    }
    
    // MARK: - Override methods
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
    // MARK: - Private
    private func createBuildings() {
        var currentX: CGFloat = -15
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            buildings.append(building)
        }
    }
    
    private func createPlayer1() {
        player1 = SKSpriteNode(imageNamed: playerName)
        player1.name = player2Name
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
    }
    
    private func createPlayer2() {
        player2 = SKSpriteNode(imageNamed: playerName)
        player2.name = player1Name
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player1.size.height) / 2))
        addChild(player2)
    }
    
    private func createBanana() {
        banana = SKSpriteNode(imageNamed: bananaName)
        banana.name = bananaName
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = false
        addChild(banana)
    }
    
    private func createPlayers() {
        createPlayer1()
        createPlayer2()
    }
    
    private func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * .pi / 180
    }
    
    // MARK: - Public
    public func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10.0
        let radians = deg2rad(degrees: angle)
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        createBanana()
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            let riseArm = SKAction.setTexture(SKTexture(imageNamed: player1Throw))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: playerName))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([riseArm, pause, lowerArm])
            player1.run(sequence)
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            let riseArm = SKAction.setTexture(SKTexture(imageNamed: player2Throw))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: playerName))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([riseArm, pause, lowerArm])
            player2.run(sequence)
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }

    public func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        if let explosion = SKEmitterNode(fileNamed: hitBuilding) {
            explosion.position = contactPoint
            addChild(explosion)
        }
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        changePlayer()
    }
    
    public func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: hitPlayer) {
            explosion.position = player.position
            addChild(explosion)
        }
        player.removeFromParent()
        banana.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            let transition = SKTransition.crossFade(withDuration: 2.0)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    public func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        viewController?.activatePlayer(number: currentPlayer)
    }
}
