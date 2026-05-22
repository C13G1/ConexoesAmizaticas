//
//  FriendNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit

class FriendNode: SKShapeNode {
    var scale: CGFloat = 0.05
    var currentTouch: UITouch?
    var score: Double
    var sprite: SKShapeNode!
    var springAnchor: SpringNode = SpringNode()
    var orbitRadius: OrbitRadius = .conhecido
    
    init(score: Double, image: Data) {
        self.score = score
        
        let path = UIBezierPath(roundedRect: CGRect(x: -128, y: -128, width: 256, height: 256), cornerRadius: 128).cgPath
        self.sprite = SKShapeNode(path: path)
        let image = UIImage(data: image)!
        self.sprite.fillTexture = SKTexture(image: image)
        self.sprite.fillColor = .white
        self.sprite.physicsBody = SKPhysicsBody(circleOfRadius: 128)
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = false
        self.sprite.isUserInteractionEnabled = false
        
        
        super.init()
        
        self.scale = scale * score / 10
        self.setScale(scale)
        self.isUserInteractionEnabled = true
        
        self.addChild(sprite)
        self.addChild(springAnchor)
        
        if self.score <= 25 {
            self.orbitRadius = .conhecido
        }
        else if self.score <= 50 {
            self.orbitRadius = .amigo
        }
        else if self.score <= 75 {
            self.orbitRadius = .amigoProximo
        }
        else {
            self.orbitRadius = .melhorAmigo
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentTouch = touch
        print("touched friend")
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentTouch = touch
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentTouch = nil
        findOrbit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func findOrbit() {
        let h = sqrt(position.x * position.x + position.y * position.y)
        let ratio = h / orbitRadius.rawValue
        let delta: Double = 1.0 / ratio
        let oldPosition = self.position
        self.position = CGPoint(x: position.x * delta, y: position.y * delta)
//        self.sprite.position = oldPosition
    }
    
    func update() {
        if let currentTouch = currentTouch {
            self.position = currentTouch.location(in: self.parent!)
        }
    }
}
