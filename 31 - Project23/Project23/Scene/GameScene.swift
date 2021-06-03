//
//  GameScene.swift
//  Project23
//
//  Created by Гнатюк Сергей on 01.06.2021.
//

import AVFoundation
import SpriteKit

final class GameScene: SKScene {
    
    // Dependencies
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var gameScore: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var bombSoundEffect: AVAudioPlayer?
    
    // Properties
    var lives = 3
    var popupType = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    var isSwooshSoundActive = false
    var isGameEnded = false
    var livesImages = [SKSpriteNode]()
    var activeEnemies = [SKSpriteNode]()
    var activeSlicePoints = [CGPoint]()
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    //project 23 challenge 1
    let xRandomPositionRange = 64...960
    let yPosition = -128
    let randomAngularVelocityRange: ClosedRange<CGFloat> = -3...3
    let randomYVelocityRange = 24...32
    let enemyVelocityX: [(CGFloat, ClosedRange<Int>)] = [
        (maxPosition: 256, range: 8...15),
        (maxPosition: 512, range: 3...5),
        (maxPosition: 768, range: -5...(-3)),
        (maxPosition: 961, range: -15...(-8))
    ]
    //project 23 challenge 2
    let enemyVelocityMultiplier = 40
    let fastEnemyVelocityMultiplier = 50
    
    // MARK: - View
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: Images.backgroundImage)
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        createGameOver()
        
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0...1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemies()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //project 23 challenge 3
        guard isGameEnded == false else { return }
        
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    
                    if node.name == Images.Extension.enemyName {
                        node.name = ""
                        subtractLife()
                        
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == Images.Extension.bombContainerName {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                    //project 23 challenge 2
                    else if node.name == Images.Extension.bombContainerName || node.name == Images.Extension.fastEnemyName {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupType) {
                    [weak self] in
                    self?.tossEnemies()
                }
                nextSequenceQueued = true
            }
        }
        var bombCount = 0
        for node in activeEnemies {
            if node.name == Images.Extension.bombContainerName {
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
        guard  isGameEnded == false else { return }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        for case let node as SKSpriteNode in nodesAtPoint {
            //project 23 challenge 2
            if node.name == Images.Extension.fastEnemyName {
                score += 4
            }
            //project 23 challenge 2
            if node.name == Images.Extension.enemyName || node.name == Images.Extension.fastEnemyName {
                if let emitter = SKEmitterNode(fileNamed: Images.Extension.sliceHitEnemy) {
                    emitter.position = node.position
                    addChild(emitter)
                }
                node.name = ""
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(by: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                score += 1
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed(Images.Sound.soundWhack, waitForCompletion: false))
            } else if node.name == Images.Extension.bombName {
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                if let emitter = SKEmitterNode(fileNamed: Images.Extension.sliceHitBomb) {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(by: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(seq)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                run(SKAction.playSoundFileNamed(Images.Sound.soundExplosion, waitForCompletion: false))
                endGame(triggeredByBomb: false)
            }
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
        gameScore = SKLabelNode(fontNamed: Images.Font.fontChalkduster)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    //project 23 challenge 3
    private func createGameOver() {
        gameOverLabel = SKLabelNode(fontNamed: Images.Font.fontChalkduster)
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.zPosition = 1
    }
    
    private func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: Images.lifeImage)
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
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
        //project 23 challenge 2
        var enemyType = Int.random(in: 0...7)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        if enemyType == 0 {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = Images.Extension.bombContainerName
            
            let bombImage = SKSpriteNode(imageNamed: Images.bombImage)
            bombImage.name = Images.Extension.bombName
            enemy.addChild(bombImage)
            
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            if let path = Bundle.main.url(forResource: Images.Extension.sliceBombFuse, withExtension: Images.Sound.soundExplosion) {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            if let emitter = SKEmitterNode(fileNamed:  Images.Extension.sliceFuse) {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
            //project 23 challenge 2
        } else if enemyType == 7 {
            enemy = SKSpriteNode(imageNamed: Images.fastPenguinImage)
            run(SKAction.playSoundFileNamed(Images.Sound.soundLaunch, waitForCompletion: false))
            enemy.name = Images.Extension.fastEnemyName
            
        } else {
            enemy = SKSpriteNode(imageNamed: Images.penguinImage)
            run(SKAction.playSoundFileNamed(Images.Sound.soundLaunch, waitForCompletion: false))
            enemy.name = Images.Extension.enemyName
        }
        //project 23 challenge 1
        let randomPosition = CGPoint(x: Int.random(in: xRandomPositionRange), y: yPosition)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: randomAngularVelocityRange)
        var randomXVelocity: Int = 1
        
        for (maxPosition, range) in enemyVelocityX {
            if randomPosition.x < maxPosition {
                randomXVelocity = Int.random(in: range)
                break
            }
        }
        
        let randomYVelocity = Int.random(in: randomYVelocityRange)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        //project 23 challenge 2
        let multiplier = enemyType == 7 ? fastEnemyVelocityMultiplier : enemyVelocityMultiplier
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * multiplier, dy: randomYVelocity * multiplier)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    private func tossEnemies() {
        guard  isGameEnded == false else { return }
        
        popupType *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
        case .one:
            createEnemy()
        case .two:
            createEnemy()
            createEnemy()
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
        case .chain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) {
                [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) {
                [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) {
                [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) {
                [weak self] in self?.createEnemy() }
        case .fastChain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) {
                [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) {
                [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) {
                [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) {
                [weak self] in self?.createEnemy() }
        }
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    private func endGame(triggeredByBomb: Bool) {
        guard  isGameEnded == false else { return }
        //project 23 challenge 3
        isGameEnded = true
        //        isPaused = true
        //        physicsWorld.speed = 0
        //      isUserInteractionEnabled = false
        nextSequenceQueued = true
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: Images.Extension.sliceLifeGone)
            livesImages[1].texture = SKTexture(imageNamed: Images.Extension.sliceLifeGone)
            livesImages[2].texture = SKTexture(imageNamed: Images.Extension.sliceLifeGone)
        }
        //project 23 challenge 3
        addChild(gameOverLabel)
        
        DispatchQueue.main.async { [weak self] in
            self?.cleanup()
        }
    }
    
    private func cleanup() {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                node.removeAllActions()
                node.removeFromParent()
                activeEnemies.remove(at: index)
            }
        }
        bombSoundEffect?.stop()
        bombSoundEffect = nil
    }
    
    private func subtractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed(Images.Sound.soundWrong, waitForCompletion: false))
        
        var life: SKSpriteNode
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        life.texture = SKTexture(imageNamed: Images.Extension.sliceLifeGone)
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(by: 1, duration: 0.1))
    }
}
