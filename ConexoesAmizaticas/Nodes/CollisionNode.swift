//
//  CollisionNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 21/05/26.
//

import SpriteKit

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
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
    }
}
