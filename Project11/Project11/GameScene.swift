//
//  GameScene.swift
//  Project11
//
//  Created by Ray Varkki on 2025-10-11.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel : SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode = false {
        didSet {
            if editingMode{
                editLabel.text = "Done"
            } else{
                editLabel.text = "Edit"
            }
        }
    }
    
    var ballsLeftLabel : SKLabelNode!
    var ballsLeft = 5 {
        didSet{
            ballsLeftLabel.text = "Balls left : \(ballsLeft)"
        }
    }
    
    var resetLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "ChalkDuster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 650)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "ChalkDuster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .right
        editLabel.position = CGPoint(x: 100, y: 650)
        addChild(editLabel)
        
        ballsLeftLabel = SKLabelNode(fontNamed: "ChalkDuster")
        ballsLeftLabel.text = "Balls left: 5"
        ballsLeftLabel.horizontalAlignmentMode = .right
        ballsLeftLabel.position = CGPoint(x: 400, y: 650)
        addChild(ballsLeftLabel)
        
        resetLabel = SKLabelNode(fontNamed: "ChalkDuster")
        resetLabel.text = "Replenish Balls"
        resetLabel.horizontalAlignmentMode = .right
        resetLabel.position = CGPoint(x: 800, y: 650)
        addChild(resetLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        physicsWorld.contactDelegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(editLabel){
            editingMode.toggle()
        }else if objects.contains(resetLabel){
            ballsLeft = 5
        }else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.name = "box"
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            } else{
                if(ballsLeft > 0){
                    ballsLeft -= 1
                    let ballTypes = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
                    let ball = SKSpriteNode(imageNamed: ballTypes[Int.random(in: 0..<ballTypes.count)])
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = CGPoint(x: location.x, y: 650)
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        }
    }
    
    func makeBouncer(at position : CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood : Bool){
        var slotBase = SKSpriteNode()
        var slotGlow = SKSpriteNode()
        
        if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        }else{
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = position
        slotGlow.position = position
        slotGlow.zPosition = -1
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball : SKNode, object : SKNode){
        if object.name == "good" {
            destroy(ball : ball)
            score += 1
            ballsLeft += 1
        } else if object.name == "bad"{
            destroy(ball: ball)
            score -= 1
        } else if object.name == "box"{
            removeBox(box: object)
        }
    }
    
    func destroy(ball : SKNode){
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func removeBox(box : SKNode){
        
        box.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball"{
            collision(between: nodeA, object: nodeB)
        }else if nodeB.name == "ball"{
            collision(between: nodeB, object: nodeA)
        }
    }
}
