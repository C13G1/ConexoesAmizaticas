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
    var orbitRadius: Double = RelationshipState.estaveis.orbitRadius
    var lastTouchLocation: CGPoint!
    private var touchStartLocation: CGPoint?

    // identifica se tap
    var onTapped: (() -> Void)?

    init(connection: Connection) {
        self.score = connection.metaManager.score
        let imageData = connection.friend.profilePicture
        let path = UIBezierPath(roundedRect: CGRect(x: -128, y: -128, width: 256, height: 256), cornerRadius: 128).cgPath
        self.sprite = SKShapeNode(path: path)
        let image = UIImage(data: imageData) ?? UIImage()
        self.sprite.fillTexture = SKTexture(image: image)
        self.sprite.fillColor = .white
        self.sprite.strokeColor = connection.metaManager.currentRelationshipState.color
        self.sprite.lineWidth = 20
        super.init()

        self.name = connection.friend.id.uuidString
        self.physicsBody = SKPhysicsBody(circleOfRadius: 128)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.isUserInteractionEnabled = false
        self.scale = scale * score / 10
        self.setScale(self.scale)
        self.isUserInteractionEnabled = true

        self.addChild(sprite)

        if self.score < 20 {
            self.orbitRadius = RelationshipState.afastados.orbitRadius
        } else if self.score < 40 {
            self.orbitRadius = RelationshipState.distantes.orbitRadius
        } else if self.score < 60 {
            self.orbitRadius = RelationshipState.estaveis.orbitRadius
        } else if self.score < 80 {
            self.orbitRadius = RelationshipState.proximos.orbitRadius
        } else {
            self.orbitRadius = RelationshipState.inseparaveis.orbitRadius
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let parent = self.parent else { return }
        currentTouch = touch
        let loc = touch.location(in: parent)
        lastTouchLocation = loc
        touchStartLocation = loc
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let parent = self.parent else { return }
        lastTouchLocation = touch.location(in: parent)
        currentTouch = touch
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            currentTouch = nil
            touchStartLocation = nil
        }
        // se movimento < que 10 é tap
        if let touch = touches.first, let parent = self.parent, let start = touchStartLocation {
            let end = touch.location(in: parent)
            let dx = end.x - start.x
            let dy = end.y - start.y
            if sqrt(dx * dx + dy * dy) < 10 {
                onTapped?()
                return
            }
        }
        if let _ = self.parent as? OrbitNode {
            findOrbit()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func findOrbit() {
        let h = sqrt(position.x * position.x + position.y * position.y)
        let ratio = h / orbitRadius
        let delta: Double = 1.0 / ratio
        let oldPosition = self.position
        let newPosition = CGPoint(x: position.x * delta, y: position.y * delta)
        let spritePosition = CGPoint(x: oldPosition.x - newPosition.x, y: oldPosition.y - newPosition.y)
        self.position = newPosition
        self.sprite.position = spritePosition
    }

    func update() {
        if let _ = currentTouch {
            self.position.x += lastTouchLocation.x - self.position.x
            self.position.y += lastTouchLocation.y - self.position.y
        }
    }
}
