//
//  CollisionNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 21/05/26.
//

import SpriteKit

/// A static physical boundary used within the relationship simulation.
///
/// `CollisionNode` provides a fixed, circular physics body. It is typically placed at the center of the scene
/// (representing the user) to prevent floating `FriendNode` instances from overlapping the center or
/// crossing into the opposite side of the screen when dragged.
class CollisionNode: SKShapeNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        let path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 200)), transform: .none)
        super.init()
        self.path = path
        self.lineWidth = 10
        self.strokeColor = .white
        self.glowWidth = 1
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: path)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
    }
}
