//
//  WhackSlot.swift
//  Project14
//
//  Created by Ray Varkki on 2025-10-25.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {

    
    var charNode : SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint){
        
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        addChild(cropNode)
    }
    
    func show(hideTime: Double){
        if isVisible{
            return
        }
        displayMud(hide : false)
        charNode.xScale = 1
        charNode.yScale = 1 
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        if Int.random(in: 0...2) == 0 {
            
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        }else
        {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)){
            [weak self] in
            self?.hide()
        }
    }
    
    func displayMud(hide : Bool){
        
        if let mudSprite = SKEmitterNode(fileNamed: "mud"){
            if hide {
                mudSprite.position = CGPoint(x: charNode.position.x, y: charNode.position.y)
            }else{
                mudSprite.position = CGPoint(x: charNode.position.x, y: charNode.position.y + 80)
            }
            
            let addMud = SKAction.run {
                [weak self] in
                self?.addChild(mudSprite)
            }
            let waitTime = SKAction.wait(forDuration: 0.5)
            let removeMud = SKAction.run {
                mudSprite.removeFromParent()
            }
            let mudSequence = SKAction.sequence([addMud, waitTime, removeMud])
            run(mudSequence)
        }
        
    }
    
    func hide() {
        if !isVisible{
            return
        }
        displayMud(hide : true)
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit(){
        isHit = true
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run{
            [weak self] in
            self?.isVisible = false
        }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
        if let smokeParticle = SKEmitterNode(fileNamed: "smoke.sks"){
            smokeParticle.position = charNode.position
            let smokeVisible = SKAction.run{
                [weak self] in
                self?.addChild(smokeParticle)
            }
            let waitTime = SKAction.wait(forDuration: 1)
            let removeSmoke = SKAction.run {
                smokeParticle.removeFromParent()
            }
            let smokeSequence = SKAction.sequence([smokeVisible, waitTime, removeSmoke])
            run(smokeSequence)
        }
        
    }
    
}

