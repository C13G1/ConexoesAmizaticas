//
//  SpringNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit

/// A non-interactive, invisible physics anchor.
///
/// `SpringNode` is utilized by `FriendsScene` to act as the fixed reference point (`bodyB`)
/// when creating an `SKPhysicsJointSpring` constraint. It ensures that a `FriendNode`
/// always pulls back to its designated mathematical location on the orbit when dragged.
class SpringNode: SKNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        self.isUserInteractionEnabled = false
        
        // Needs an empty physics body just so the SpriteKit physics engine can attach a joint to it
        physicsBody = SKPhysicsBody()
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
    }
}
