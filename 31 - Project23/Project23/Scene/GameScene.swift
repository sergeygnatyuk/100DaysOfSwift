//
//  GameScene.swift
//  Project23
//
//  Created by Гнатюк Сергей on 01.06.2021.
//

import AVFoundation
import SpriteKit

class GameScene: SKScene {
    
    // Dependencies
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var gameScore: SKLabelNode!
    var bombSoundEffect: AVAudioPlayer?
    
    // Properties
    let backgroundImage = "sliceBackground"
    let lifeImageName = "sliceLife"
    let bombImageName = "sliceBomb"
    let fontName = "Chalkduster"
    let penguinImage = "penguin"
    let soundName = "launch.caf"
    let enemyName = "enemy"
    let bombContainerName = "bombContainer"
    let bombName = "bomb"
    let sliceBombFuse = "sliceBombFuse"
    let extensionBombFuse = "caf"
    let sliceFuse = "sliceFuse"
    var lives = 3
    var liveImages = [SKSpriteNode]()
    var activateEnemies = [SKSpriteNode]()
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    // MARK: - View
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: backgroundImage)
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
    }
    
    override func update(_ currentTime: TimeInterval) {
        var bombCount = 0
        for node in activateEnemies {
            if node.name == bombContainerName {
                bombCount += 1
                break
            }
        }
        if bombCount == 0 {
            
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    // MARK: - Touches methods
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }
    
    // MARK: - Private
    private func createScore() {
        gameScore = SKLabelNode(fontNamed: fontName)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    private func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: lifeImageName)
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            liveImages.append(spriteNode)
        }
    }
    
    private func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    private func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    private func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    private func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        if enemyType == 0 {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = bombContainerName
            
            let bombImage = SKSpriteNode(imageNamed: bombImageName)
            bombImage.name = bombName
            enemy.addChild(bombImage)
            
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            if let path = Bundle.main.url(forResource: sliceBombFuse, withExtension: extensionBombFuse) {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            if let emitter = SKEmitterNode(fileNamed: sliceFuse) {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
             
        } else {
            enemy = SKSpriteNode(imageNamed: penguinImage)
            run(SKAction.playSoundFileNamed(soundName, waitForCompletion: false))
            enemy.name = enemyName
        }
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activateEnemies.append(enemy)
    }
}
