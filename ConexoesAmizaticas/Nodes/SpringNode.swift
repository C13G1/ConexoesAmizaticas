//
//  SpringNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit


class SpringNode: SKNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        self.isUserInteractionEnabled = false
        physicsBody = SKPhysicsBody()
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
    }
}
