//
//  HealthComponent.swift
//  Bodyguard
//
//  Created by HEssam on 4/9/24.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {
    
    @GKInspectable var currentHealth: Int = 3
    @GKInspectable var maxHealth: Int = 3
    
    private let healthFull = SKTexture(imageNamed: "health_full")
    private let healthEmpty = SKTexture(imageNamed: "health_empty")
    
    override func didAddToEntity() {
        if let healthMeter = SKReferenceNode(fileNamed: "Health") {
            healthMeter.position = CGPoint(x: 0, y: 500)
            healthMeter.setScale(3.0)
            componentNode.addChild(healthMeter)
            
            updateHealth(0, forNode: componentNode)
        }
    }
    
    func updateHealth(_ value: Int, forNode node: SKNode?) {
        currentHealth += value
        
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
        
        for barNum in 1...maxHealth {
            setupBar(at: barNum)
        }
    }
    
    func decrease() {
        currentHealth += -1
        
        for barNum in 1...maxHealth {
            setupBar(at: barNum)
        }
    }
    
    func isAlive() -> Bool {
        currentHealth > 0
    }
    
    func setupBar(at num: Int) {
        if let health = componentNode.childNode(withName: ".//bar_\(num)")
            as? SKSpriteNode {
            if currentHealth >= num {
                health.texture = healthFull
                
            } else {
                health.texture = healthEmpty
                health.colorBlendFactor = 0.0
            }
        }
    }
    
    override class var supportsSecureCoding: Bool {
        true
    }
}

extension GKComponent {
    
    var componentNode: SKNode {
        if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
            return node
        }
        
        return SKNode()
    }
}

