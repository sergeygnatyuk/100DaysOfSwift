//
//  GameScene.swift
//  Project26
//
//  Created by Гнатюк Сергей on 08.06.2021.
//

import SpriteKit
import CoreMotion

final class GameScene: SKScene {
    
    // Properties
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager?
    var scoreLabel: SKLabelNode!
    var fontStyle = "Chalkduster"
    var isGameOver = false
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // MARK: - View
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: FileNameModel.background)
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        scoreLabel = SKLabelNode(fontNamed: fontStyle)
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        loadLevel()
        createPlayer()
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    // MARK: - Private
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
                    createBlockNode(position)
                } else if letter == "v" {
                    createVortexNode(position)
                } else if letter == "s" {
                    createStarNode(position)
                } else if letter == "f" {
                    createFinishNode(position)
                } else if letter == " " {
                    
                } else {
                    fatalError("Unknown level letter \(letter)")
                }
            }
        }
    }
    
    private func createFinishNode(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: FileNameModel.finish)
        node.name = FileNameModel.finish
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    private func createStarNode(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: FileNameModel.star)
        node.name = FileNameModel.star
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    private func createVortexNode(_ position: CGPoint) {
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
    }
    
    private func createBlockNode(_ position: CGPoint) {
        let node = SKSpriteNode(imageNamed: FileNameModel.block)
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    private func createPlayer() {
        player = SKSpriteNode(imageNamed: FileNameModel.player)
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    // MARK: - Touches methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let  touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == FileNameModel.vortex {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == FileNameModel.star {
            node.removeFromParent()
            score += 1
        } else if node.name == FileNameModel.finish {
            
        }
    }
}
