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
    // project 29 challenge 1
    let chalkDuster = "Chalkduster"
    let snowName = "Snow"
    var player1Label: SKLabelNode!
    var player2Label: SKLabelNode!
    var scorePlayer1 = 0 {
        didSet {
            player1Label.text = "Score Player One: \(scorePlayer1)"
        }
    }
    var scorePlayer2 = 0 {
        didSet {
            player2Label.text = "Score Player Two: \(scorePlayer2)"
        }
    }
    // project 29 challenge 3
    var snow: SKEmitterNode!
   // public var windSpeedLabel: SKLabelNode!
    
    // MARK: - View
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
        physicsWorld.contactDelegate = self
        // project 29 challenge 1
        createPlayer1Label()
        createPlayer2Label()
        // project 29 challenge 3
        createSnow()
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
    // project 29 challenge 1
    private func createPlayer1Label() {
        player1Label = SKLabelNode(fontNamed: chalkDuster)
        player1Label.text = "Score Player One: 0"
        player1Label.position = CGPoint(x: 50, y: 680)
        player1Label.horizontalAlignmentMode = .left
        player1Label.fontSize = 20
        addChild(player1Label)
    }
    
    private func createPlayer2Label() {
        player2Label = SKLabelNode(fontNamed: chalkDuster)
        player2Label.text = "Score Player Two: 0"
        player2Label.position = CGPoint(x: 950, y: 680)
        player2Label.horizontalAlignmentMode = .right
        player2Label.fontSize = 20
        addChild(player2Label)
    }
    
    private func createSnow() {
        guard var snow1 = snow else { return }
        snow1 = SKEmitterNode(fileNamed: snowName) ?? snow
        snow1.position = CGPoint(x: 512, y: 800)
        addChild(snow1)
        snow.zPosition = -1
    }
    
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
    // project 29 challenge 1
    private func startNewGame() {
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
    
    // MARK: - Public
//    // project 29 challenge 3
//    public func createWindSpeedLabel() {
//        windSpeedLabel = SKLabelNode(fontNamed: chalkDuster)
//        windSpeedLabel.text = "SWind Speed: 0"
//        windSpeedLabel.position = CGPoint(x: 425, y: 680)
//        windSpeedLabel.horizontalAlignmentMode = .center
//        windSpeedLabel.fontSize = 20
//        addChild(windSpeedLabel)
//    }
    
    public func setWindSpeed(_ speed: CGFloat) {
        guard let snow = snow else { return }
        physicsWorld.gravity = CGVector(dx: speed, dy: 9.8)
        snow.xAcceleration = speed
    }
    
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
        // project 29 challenge 1
        if currentPlayer == 1 {
            scorePlayer1 += 1
        } else {
            scorePlayer2 += 1
        }
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        // project 29 challenge 1
        if scorePlayer1 == 3 || scorePlayer2 == 3 {
            startNewGame()
        }
        changePlayer()
    }
    
    public func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: hitPlayer) {
            explosion.position = player.position
            addChild(explosion)
        }
        player.removeFromParent()
        banana.removeFromParent()
        // project 29 challenge 1
        startNewGame()
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
