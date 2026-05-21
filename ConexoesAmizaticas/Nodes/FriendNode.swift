//
//  FriendNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit

class FriendNode: SKShapeNode {
    var connection: Connection!
    var scale: CGFloat = 0.05
    var currentTouch: UITouch?
    
    
    init(connection: Connection) {
        super.init()
        self.connection = connection
        self.scale = scale * connection.metaManager.score / 10
        self.path = UIBezierPath(roundedRect: CGRect(x: -128, y: -128, width: 256, height: 256), cornerRadius: 128).cgPath
        let image = UIImage(data: connection.friend.profileImage)!
        let texture = SKTexture(image: image)
        self.fillColor = .white
        self.fillTexture = texture
        self.physicsBody = SKPhysicsBody(circleOfRadius: 128)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.isUserInteractionEnabled = true
        self.setScale(scale)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentTouch = touch
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentTouch = touch
        self.position = currentTouch!.location(in: self.scene!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
    }
}
