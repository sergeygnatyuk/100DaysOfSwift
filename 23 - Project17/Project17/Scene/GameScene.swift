//
//  GameScene.swift
//  Project17
//
//  Created by Гнатюк Сергей on 14.05.2021.
//

import SpriteKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
    // Dependencies
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var gameTimer: Timer?
    // Properties
    let fileNamedStrafield = "starfield"
    let fileNamedPlayer = "player"
    let fontNamedChalkduster = "Chalkduster"
    let fileNamedExplosion = "explosion"
    var possibleEnemies = ["ball", "hammer", "tv"]
    // project 17 challenge 2
    var interval = 0.60
    var countTrash = 20
    var isGameOver = false
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // MARK: - Override methods
    override func didMove(to view: SKView) {
        gameTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: fileNamedStrafield)
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: fileNamedPlayer)
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: fontNamedChalkduster)
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        gameOverLabel = SKLabelNode(fontNamed: fontNamedChalkduster)
        gameOverLabel.position = CGPoint(x: 520, y: 500)
        gameOverLabel.horizontalAlignmentMode = .center
        addChild(gameOverLabel)
        gameOverLabel.isHidden = true
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        player.position = location
    }
    // project 17 challenge 1
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isGameOver = true
        gameTimer?.invalidate()
        // project 17 challenge 3
        player.isHidden = true
        starfield.isHidden = true
        scoreLabel.position = CGPoint(x: 520, y: 400)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.text = "Your Final Score \(score)"
        gameOverLabel.isHidden = false
        gameOverLabel.text = "GAME OVER"
    }
    
    // MARK: - @objc methods
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        // project 17 challenge 2
        countTrash -= 1
        if countTrash == 0 {
            countTrash = 20
            gameTimer?.invalidate()
            interval -= 0.1
            if interval > 0 {
                gameTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
        }
    }
    
    // MARK: - Public
    public func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: fileNamedExplosion)!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
    }
}
