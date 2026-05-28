//
//  FriendNode.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit
import UIKit

// SKTexture ignores UIImage.imageOrientation — normalize before creating textures
extension UIImage {
    var normalized: UIImage {
        guard imageOrientation != .up else { return self }
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

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
        let state = connection.metaManager.currentRelationshipState
        let imageData = connection.friend.profilePicture
        let path = UIBezierPath(roundedRect: CGRect(x: -128, y: -128, width: 256, height: 256), cornerRadius: 128).cgPath
        self.sprite = SKShapeNode(path: path)
        let image = (UIImage(data: imageData) ?? UIImage()).normalized
        self.sprite.fillTexture = SKTexture(image: image)
        self.sprite.fillColor = .white
        self.sprite.strokeColor = state.color
        self.sprite.lineWidth = 20
        super.init()

        self.name = connection.friend.id.uuidString
        self.physicsBody = SKPhysicsBody(circleOfRadius: 128)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.isUserInteractionEnabled = false
        let nodeScale = state.nodeSize / 256.0
        self.scale = nodeScale
        self.setScale(nodeScale)
        self.isUserInteractionEnabled = true
        self.orbitRadius = state.orbitRadius

        self.addChild(sprite)
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
