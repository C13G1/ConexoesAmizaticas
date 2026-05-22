//
//  OrbitNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 22/05/26.
//

import SpriteKit

class OrbitNode: SKNode {
    let orbitSpeed: Double!
    let orbitRadius: OrbitRadius!
    
    init(orbitRadius: OrbitRadius) {
        self.orbitRadius = orbitRadius
        switch self.orbitRadius {
        case .conhecido:
            self.orbitSpeed = 4
        case .amigo:
            self.orbitSpeed = 3
        case .amigoProximo:
            self.orbitSpeed = 2
        case .melhorAmigo:
            self.orbitSpeed = 1
        default:
            self.orbitSpeed = 1
        }
        super.init()
        self.isUserInteractionEnabled = false
    }
    
    
    
    func update() {
        self.zRotation += 0.003 * orbitSpeed
        for child in self.children {
            if let child = child as? FriendNode {
                child.update()
            }
        }
    }
    
    func addFriend(friend: FriendNode) {
        let x = Double.random(in: -1...1)
        let y = Double.random(in: -1...1)
        let h = sqrt(x * x + y * y)
        let ratio = h / self.orbitRadius.rawValue
        let delta: Double = 1.0 / ratio
        friend.position = CGPoint(x: x * delta, y: y * delta)
        addChild(friend)
        let spring = SKPhysicsJointSpring.joint(withBodyA: friend.sprite.physicsBody!,
                                                bodyB: friend.springAnchor.physicsBody!,
                                                anchorA: friend.sprite.position,
                                                anchorB: friend.springAnchor.position)
        spring.frequency = 0.8
        spring.damping = 0.5
        self.scene!.physicsWorld.add(spring)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
