//
//  OrbitNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro fixed Grandin on 22/05/26.
//

import SpriteKit

/// A logical container representing a specific orbital track in the relationship visualizer.
///
/// The `OrbitNode` constantly rotates over time, carrying all `FriendNode` instances attached to it.
/// It creates the dynamic, solar-system-like visual effect where closer friends orbit faster and farther friends orbit slower.
class OrbitNode: SKNode {
    
    /// The rotational velocity of this specific orbit.
    let orbitSpeed: Double!
    
    /// The fixed distance from the center where friends in this tier are placed.
    let orbitRadius: OrbitRadius!
    
    init(orbitRadius: OrbitRadius) {
        self.orbitRadius = orbitRadius
        
        // Closer orbits spin faster to create a parallax/depth effect
        switch self.orbitRadius {
        case .afastados:
            self.orbitSpeed = 5
        case .distantes:
            self.orbitSpeed = 4
        case .estaveis:
            self.orbitSpeed = 3
        case .proximos:
            self.orbitSpeed = 2
        case .inseparaveis:
            self.orbitSpeed = 1
        default:
            self.orbitSpeed = 1
        }
        
        super.init()
        self.isUserInteractionEnabled = false
    }
    
    /// Advances the rotation of the orbit and propagates the update cycle to all hosted friends.
    func update() {
        self.zRotation += 0.003 * orbitSpeed
        for child in self.children {
            if let child = child as? FriendNode {
                child.update()
            }
        }
    }
    
    /// Spawns a friend on this orbit track and tethers them using a physics spring.
    ///
    /// - Parameter friend: The initialized `FriendNode` to be added to this tier.
    func addFriend(friend: FriendNode) {
        // Calculate a random spawn point strictly along the circumference of the orbitRadius
        let x = Double.random(in: -1...1)
        let y = Double.random(in: -1...1)
        let h = sqrt(x * x + y * y)
        let ratio = h / self.orbitRadius.rawValue
        let delta: Double = 1.0 / ratio
        friend.position = CGPoint(x: x * delta, y: y * delta)
        
        addChild(friend)
        
        // Tether the node to its spot using a spring. This allows the user to drag the friend around,
        // but it will elastically snap back to the orbit once released.
        let springAnchor = SpringNode()
        let spring = SKPhysicsJointSpring.joint(withBodyA: friend.sprite.physicsBody!,
                                                bodyB: springAnchor.physicsBody!,
                                                anchorA: friend.sprite.position,
                                                anchorB: springAnchor.position)
        spring.frequency = 0.8
        spring.damping = 0.5
        
        self.scene!.physicsWorld.add(spring)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
