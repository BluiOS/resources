//
//  GameScene.swift
//  Bodyguard
//
//  Created by HEssam on 4/9/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var foregroundFrame: CGRect?
    private var enemyCounter: Int = 0
    private var goblin: SKSpriteNode?

    override func didMove(to view: SKView) {
        setupBackground()
        setupGround()
        createGoblin()
        
        startTimerForCreatingEnemy()
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background_1")
        background.name = "background"
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        background.position = CGPoint(x: 0, y: 0)
        addChild(background)
    }
    
    func setupGround() {
        let foreground = SKSpriteNode(imageNamed: "foreground_1")
        foreground.name = "foreground"
        foreground.anchorPoint = CGPoint(x: 0, y: 0)
        foreground.zPosition = 1
        foreground.position = CGPoint(x: 0, y: 0)
        foreground.size.height = frame.size.height * 0.3
        foregroundFrame = foreground.frame
        
        // Add physics body
        foreground.physicsBody = SKPhysicsBody(edgeLoopFrom: foreground.frame)
        foreground.physicsBody?.affectedByGravity = false

        addChild(foreground)
    }
    
    func createEnemy() {
        guard let foregroundFrame else { return }
        let enemy = Enemy(suffixName: "\(enemyCounter)")
        enemy.position = CGPoint(x: size.width - 100, y: foregroundFrame.maxY)
        enemy.setupConstraints(floor: foregroundFrame.maxY)
        enemy.delegate = self
        addChild(enemy)
        
        enemy.moveBy(dx: frame.width)
        
        enemyCounter += 1
    }
    
    func createGoblin() {
        let goblin = SKSpriteNode(imageNamed: "goblin")
        goblin.size = .init(width: 50, height: 50)
        goblin.position = CGPoint(x: 50, y: frame.size.height - 50)
        goblin.zPosition = 10
        addChild(goblin)
        
        self.goblin = goblin
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let nodeAtPoint = atPoint(pos)
        if let touchedNode = nodeAtPoint as? Enemy {
            guard touchedNode.name?.starts(with: "enemy_") == true else {
                return
            }
            
            touchedNode.decreaseHealth()
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func startTimerForCreatingEnemy() {
        let waitAction = SKAction.wait(forDuration: 2.0)
        let createEnemyAction = SKAction.run({ [weak self] in
            guard let self else { return }
            
            createEnemy()
        })
        
        run(SKAction.repeatForever(SKAction.sequence([waitAction, createEnemyAction])))
    }
    
    func shakeSprite(layer: SKSpriteNode, duration: Float) {
            
            let position = layer.position
            
            let amplitudeX:Float = 10
            let amplitudeY:Float = 6
            let numberOfShakes = duration / 0.04
            var actionsArray:[SKAction] = []
            for _ in 1...Int(numberOfShakes) {
                let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
                let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
                let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
                shakeAction.timingMode = SKActionTimingMode.easeOut
                actionsArray.append(shakeAction)
                actionsArray.append(shakeAction.reversed())
            }
            
            actionsArray.append(SKAction.move(to: position, duration: 0.0))
            
            let actionSeq = SKAction.sequence(actionsArray)
            layer.run(actionSeq)
        }
}

extension GameScene: EnemyDelegate {
    
    func showAlertToUser() {
        guard let goblin else { return }
        shakeSprite(layer: goblin, duration: 1.0)
    }
}
