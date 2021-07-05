//
//  WhackSlot.swift
//  Project14
//
//  Created by Гнатюк Сергей on 07.05.2021.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    // Dependencies
    public var charNode: SKSpriteNode!
    private var mudEffect: SKEmitterNode!
    private  var sprite: SKSpriteNode!
    
    // Properties
    public var isVisible = false
    public var isHit = false
    private let whackHole = "whackHole"
    private let whackMask = "whackMask"
    private let penguinGood = "penguinGood"
    private let penguinEvil = "penguinEvil"
    private let character = "character"
    private let MudEmitter = "MudEmitter"
    private let charFriend = "charFriend"
    private let charEnemy = "charEnemy"
    
    //MARK: - Public
    
    public func configure(at position: CGPoint) {
        self.position = position
        
        sprite = SKSpriteNode(imageNamed: whackHole)
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: whackMask)
        
        charNode = SKSpriteNode(imageNamed: penguinGood)
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = character
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    public func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        //project 14 challenge 3
        if mudEffect == nil {
            mudEffect = SKEmitterNode(fileNamed: MudEmitter)
            mudEffect.position = CGPoint(x: sprite.position.x, y: sprite.position.y - 40)
            addChild(mudEffect)
        }
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: penguinGood)
            charNode.name = charFriend
        } else {
            charNode.texture = SKTexture(imageNamed: penguinEvil)
            charNode.name = charEnemy
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    public func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        //project 14 challenge 3
        let notVisible = SKAction.run { [weak self] in
            if self?.mudEffect != nil {
                self?.mudEffect.removeFromParent()
                self?.mudEffect = nil
            }
            self?.isVisible = false
        }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
    
    public func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        //project 14 challenge 3
        if mudEffect != nil {
            mudEffect.removeFromParent()
            mudEffect = nil
        }
        isVisible = false
    }
}
