//
//  GameScene.swift
//  Project 16-18 Milestone
//
//  Created by Гнатюк Сергей on 18.05.2021.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    // Dependencies
    var gameTimer: Timer?
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    // Properties
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
    var timeRemained = 60 {
        didSet {
            timeLabel?.text = "\(timeRemained) sec"
        }
    }
    
    let possibleTargets = ["ball", "hammer", "tv", "penguinGood"]
    let timesNewRomanPSMT = "TimesNewRomanPSMT"
    
    // MARK: - Override
    override func didMove(to view: SKView) {
        
        let titleBox = SKSpriteNode(color: .blue, size: CGSize(width: 1024, height: 158))
        titleBox.position = CGPoint(x: 512, y: 79)
        
        addChild(titleBox)
        
        let dividerBox2 = SKSpriteNode(color: .blue, size: CGSize(width: 1024, height: 30))
        dividerBox2.position = CGPoint(x: 512, y: 158 + 150 + 15)
        addChild(dividerBox2)
        
        let dividerBox1 = SKSpriteNode(color: .blue, size: CGSize(width: 1024, height: 30))
        dividerBox1.position = CGPoint(x: 512, y: 158 + 150 + 30 + 150 + 15)
        addChild(dividerBox1)
        
        let scoreBox = SKSpriteNode(color: .blue, size: CGSize(width: 1024, height: 100))
        scoreBox.position = CGPoint(x: 512, y: 158+150+30+150+30+150+50)
        addChild(scoreBox)
        
        scoreLabel = SKLabelNode(fontNamed: UIFont(name: timesNewRomanPSMT, size: 100)?.fontName)
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: 200, y: 710)
        addChild(scoreLabel)
        
        timeLabel = SKLabelNode(fontNamed: UIFont(name: timesNewRomanPSMT, size: 100)?.fontName)
        timeLabel.text = "60 sec"
        timeLabel.fontSize = 50
        timeLabel.position = CGPoint(x: 850, y: 710)
        addChild(timeLabel)
        
        let titleLabel = SKLabelNode(fontNamed: UIFont(name: timesNewRomanPSMT, size: 100)?.fontName)
        titleLabel.text = "SHOOTING GALLERY"
        titleLabel.fontSize = 80
        titleLabel.position = CGPoint(x: 512, y: 50)
        addChild(titleLabel)
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "ball" || node.name == "hammer" || node.name == "tv" {
                if let emitter = SKEmitterNode(fileNamed: "SparkParticles") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                if node.name == "hammer" {
                    score += 20
                    showPointLabel(at: node.position, point: 20)
                } else {
                    score += 5
                    showPointLabel(at: node.position, point: 5)
                }
                node.removeFromParent()
                
            } else if node.name == "penguinGood" {
                showWarnLabel(at: node.position)
                score -= 5
            }
        }
    }
    
    // MARK: - @objc methods
    @objc func createTarget() {
        if timeRemained <= 0 {
            finishGame()
            return
        }
        timeRemained -= 1
        
        guard let target = possibleTargets.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: target)
        sprite.name = target
        let moveToLeft = SKAction.moveBy(x: -1200, y: 0, duration: 6.0)
        let moveToRight = SKAction.moveBy(x: 1200, y: 0, duration: 6.0)
        
        let rowPosY: [CGFloat] = [158, 338, 518]
        
        if let posY = rowPosY.randomElement() {
            if posY == 338 {
                sprite.position = CGPoint(x: -100, y: posY + sprite.size.height/2.0)
                addChild(sprite)
                sprite.run(moveToRight)
            } else {
                sprite.position = CGPoint(x: 1100, y: posY + sprite.size.height/2.0)
                addChild(sprite)
                sprite.run(moveToLeft)
            }
        }
    }
    
    // MARK: - Private
    private func finishGame() {
        gameTimer?.invalidate()
        let gameoverLabel = SKLabelNode(fontNamed: timesNewRomanPSMT)
        gameoverLabel.text = "Game Over"
        gameoverLabel.fontSize = 100
        gameoverLabel.fontColor = .black
        gameoverLabel.position = CGPoint(x: 512, y: 384)
        gameoverLabel.zPosition = 1
        addChild(gameoverLabel)
    }
    
    private func showPointLabel(at location: CGPoint, point: Int) {
        let label = SKLabelNode(fontNamed: UIFont(name: timesNewRomanPSMT, size: 100)?.fontName)
        label.fontColor = .blue
        label.text = "+\(point)"
        label.position = location
        label.zPosition = 1
        addChild(label)
        
        label.run(SKAction.moveBy(x: 0, y: 60, duration: 0.5))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak label] in
            label?.removeFromParent()
        }
    }
    
    private func showWarnLabel(at location: CGPoint) {
        let label = SKLabelNode(fontNamed: UIFont(name: timesNewRomanPSMT, size: 100)?.fontName)
        label.numberOfLines = 0
        label.fontColor = .red
        label.text = "-5\nDon't shoot me!"
        label.position = location
        label.zPosition = 1
        addChild(label)
        
        label.run(SKAction.moveBy(x: 0, y: 60, duration: 0.5))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak label] in
            label?.removeFromParent()
        }
    }
}
