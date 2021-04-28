//
//  GameScene.swift
//  Project11
//
//  Created by Гнатюк Сергей on 27.04.2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
        
    //Properties
    private let imageName1 = "background"
    private let imageName2 = "ballRed"
    private let imageName3 = "bouncer"
    private let imageName4 = "slotBaseGood"
    private let imageName5 = "slotBaseBad"
    private let imageName6 = "slotGlowGood"
    private let imageName7 = "slotGlowBad"
    private let slotNameGood = "good"
    private let slotNameBad = "bad"
    private let ballName = "ball"
    private let fontName = "Chalkduster"
    private var scoreLabel: SKLabelNode!
    private var editLabel: SKLabelNode!
    
    //Observers
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    //MARK: - Override
    
    override func didMove(to view: SKView) {
        let background =  SKSpriteNode(imageNamed: imageName1)
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: fontName)
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: fontName)
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 898, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1),
                                                      green: CGFloat.random(in: 0...1),
                                                      blue: CGFloat.random(in: 0...1),
                                                      alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            } else {
                let ball = SKSpriteNode(imageNamed: imageName2)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = location
                ball.name = ballName
                addChild(ball)
            }
        }
    }
    
    //MARK: - Private
    
    private func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: imageName3)
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    private func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: imageName4)
            slotGlow = SKSpriteNode(imageNamed: imageName6)
            slotBase.name = slotNameGood
        } else {
            slotBase = SKSpriteNode(imageNamed: imageName5)
            slotGlow = SKSpriteNode(imageNamed: imageName7)
            slotBase.name = slotNameBad
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    private func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == slotNameGood {
            destroy(ball: ball)
            score += 1
        } else if object.name == slotNameBad {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    private func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    
    //MARK: - Public
    
    public func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == ballName {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == ballName {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
