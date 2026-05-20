//
//  FriendNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit

class FriendNode: SKShapeNode {
    var connection: Connection!
    var scale: CGFloat = 0.01
    
    
    init(connection: Connection) {
        super.init()
        self.scale = scale * connection.metaManager.score
        self.path = UIBezierPath(roundedRect: CGRect(x: -512, y: -512, width: 1024, height: 1024), cornerRadius: 512).cgPath
        let image = UIImage(data: connection.friend.profileImage)!
        let texture = SKTexture(image: image)
        self.fillColor = .white
        self.fillTexture = texture
        self.connection = connection
        self.physicsBody = SKPhysicsBody(circleOfRadius: 512)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.isUserInteractionEnabled = true
        self.setScale(scale)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
    }
}
