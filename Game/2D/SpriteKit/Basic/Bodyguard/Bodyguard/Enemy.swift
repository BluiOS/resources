//
//  Enemy.swift
//  Bodyguard
//
//  Created by HEssam on 4/9/24.
//

import Foundation
import SpriteKit
import GameplayKit

protocol EnemyDelegate: AnyObject {
    func showAlertToUser()
}

final class Enemy: SKSpriteNode {
    
    private var runTextures: [SKTexture] = []
    private var entities: [GKEntity] = [GKEntity]()
    
    weak var delegate: EnemyDelegate?
    
    convenience init(suffixName: String) {
        self.init()
        
        self.name = "enemy_\(suffixName)"
    }
    
    init() {
        let texture = SKTexture(imageNamed: "enemy_0")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        runTextures.reserveCapacity(8)
        self.runTextures = self.loadTextures(atlas: "enemy", prefix: "enemy_",
                                             startsAt: 0, stopsAt: 7)
        
        setScale(0.2)
        anchorPoint = CGPoint(x: 0.5, y: 0.0)
        zPosition = 3
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size,
                                         center: CGPoint(x: 0.0, y: self.size.height / 2))
        
        startAnimation(textures: runTextures, speed: 0.1, name: "run", count: 0,
                       resize: false, restore: true)
        
        loadHealthMeter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(floor: CGFloat) {
        let range = SKRange(lowerLimit: floor, upperLimit: floor)
        let lockToPlatform = SKConstraint.positionY(range)
        
        constraints = [ lockToPlatform ]
    }
    
    func moveBy(dx: CGFloat) {
        let dxNeedToMove = dx - frame.width
        let moveAction = SKAction.move(by: CGVector(dx: -dxNeedToMove, dy: 0), duration: 8.0)
        run(moveAction)
        
        run(moveAction) { [weak self] in
            guard let self else { return }
            guard let health = getHealth() else { return }
            
            if health.currentHealth > 0 { // send notif to user
                delegate?.showAlertToUser()
            }
            
            self.removeFromParent()
        }
    }
    
    func getHealth() -> HealthComponent? {
        guard let entity = entities.first else {
            return nil
        }
        
        let component = entity.components.first {
            $0 is HealthComponent
        } as? HealthComponent
        
        guard let health = component else {
            return nil
        }
        
        return health
    }
    
    func decreaseHealth() {
        guard let health = getHealth() else { return }
        
        health.decrease()
        
        if !health.isAlive() {
            removeFromParent()
        }
    }
    
    func loadTextures(atlas: String, prefix: String,
                      startsAt: Int, stopsAt: Int) -> [SKTexture] {
        var textureArray = [SKTexture]()
        let textureAtlas = SKTextureAtlas(named: atlas)
        for i in startsAt...stopsAt {
            let textureName = "\(prefix)\(i)"
            let temp = textureAtlas.textureNamed(textureName)
            textureArray.append(temp)
        }
        
        return textureArray
    }
    
    func startAnimation(textures: [SKTexture], speed: Double, name: String,
                        count: Int, resize: Bool, restore: Bool) {
        let animation = SKAction.animate(with: textures, timePerFrame: speed,
                                         resize: resize, restore: restore)
        
        if count == 0 {
            // Run animation until stopped
            let repeatAction = SKAction.repeatForever(animation)
            run(repeatAction, withKey: name)
            
        } else if count == 1 {
            run(animation, withKey: name)
            
        } else {
            let repeatAction = SKAction.repeat(animation, count: count)
            run(repeatAction, withKey: name)
        }
    }
    
    func loadHealthMeter() {
        let entity = GKEntity()
        let nodeComponent = GKSKNodeComponent(node: self)
        let component = HealthComponent()
        entity.addComponent(nodeComponent)
        entity.addComponent(component)
        entities.append(entity)
    }
}

