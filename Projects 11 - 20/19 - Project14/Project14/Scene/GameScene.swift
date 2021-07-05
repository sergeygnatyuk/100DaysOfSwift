//
//  GameScene.swift
//  Project14
//
//  Created by Гнатюк Сергей on 07.05.2021.
//

import SpriteKit

class GameScene: SKScene {
    
    // Dependencies
    private var gameScore: SKLabelNode!
    private var slots = [WhackSlot]()
    
    // Properties
    private var score = 0 {
        didSet {
            gameScore.text = "Score \(score)"
        }
    }
    private var popupTime = 0.85
    private var numRounds = 0
    private let animationSmoke = "SmokeEmitter"
    private let charEnemy = "charEnemy"
    private let charFriend = "charFriend"
    private let whackBackground = "whackBackground"
    private let chalkDuster = "Chalkduster"
    private let gameOverImage = "gameOver"
    private let gameOverCaf = "gameOver.caf"
    private let whackBadCaf = "whackBad.caf"
    private let whackCaf = "whack.caf"
    
    
    //MARK: - Override
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: whackBackground)
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: chalkDuster)
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 470)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            //project 14 challenge 3
            if let smokeEffect = SKEmitterNode(fileNamed: animationSmoke) {
                smokeEffect.position = whackSlot.position
                addChild(smokeEffect)
            }
            
            if node.name == charFriend {
    
                score -= 5
                run(SKAction.playSoundFileNamed(whackBadCaf, waitForCompletion: false))
                
            } else if node.name == charEnemy {
                
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed(whackCaf, waitForCompletion: false))
            }
        }
    }
    
    //MARK: - Private
    
   private func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
   private func createEnemy() {
    numRounds += 1
    if numRounds >= 15 {    // change value on 30!!!!!!!!!!!!!!!!!!!!!!!!!
        for slot in slots {
            slot.hide()
        }
        let gameOver = SKSpriteNode(imageNamed: gameOverImage)
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        //project 14 challenge 1
        run(SKAction.playSoundFileNamed(gameOverCaf, waitForCompletion: false))
        //project 14 challenge 2
        gameScore.text = "Final Score \(score)"
        gameScore.position = CGPoint(x: 320, y: 270)
        gameScore.zPosition = 1
        return
    }
    
        popupTime *= 0.991
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)}
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
}
