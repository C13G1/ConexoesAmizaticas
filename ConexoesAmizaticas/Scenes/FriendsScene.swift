//
//  FriendsScene.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit

let MAX_RADIUS: Double = 400
let MIN_RADIUS: Double = 100

class FriendsScene: SKScene {
    var connections: Set<Connection> = Set()
    var firstTouch: UITouch!
    var secondTouch: UITouch!
    var pinchDistance: Double!
    var touchAngle: CGFloat = 0
    var rootNode: SKNode = SKNode()
    var lastTouchLocation: CGPoint!
    var deltaAngle: Double = 0
    let sceneType: SceneType!

    // identifica o toque na BOLHA
    var onFriendTapped: ((Connection) -> Void)?
    // identifica quando toca no vacuo
    var onSpiralTapped: (() -> Void)?

    // diferencia tap de drag
    private var touchStartedOnSpiral = false
    private var touchStartLocation: CGPoint?

    init(size: CGSize, connections: Set<Connection>, sceneType: SceneType) {
        self.sceneType = sceneType
        super.init(size: size)
        self.connections = connections
        self.backgroundColor = .lightBackground
        self.addChild(rootNode)
        if sceneType == .initial {
            initBackground()
            initFriends()
        }
        initCamera()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCamera() {
        let camera = SKCameraNode()
        self.camera = camera
        addChild(camera)
    }

    func initBackground() {
        let spiral = SKSpriteNode(texture: SKTexture(imageNamed: "Spiral"), size: CGSize(width: 122, height: 122))
        spiral.name = "spiral"
        spiral.physicsBody = SKPhysicsBody(circleOfRadius: (spiral.size.width - 35) / 2)
        spiral.physicsBody?.affectedByGravity = false
        spiral.physicsBody?.isDynamic = false
        self.rootNode.addChild(spiral)
    }

    func initFriends() {
        for connection in connections {
            addFriendNode(for: connection)
        }
    }

    private func addFriendNode(for connection: Connection) {
        let friend = FriendNode(connection: connection)
        friend.onTapped = { [weak self] in
            self?.onFriendTapped?(connection)
        }
        var randomX = CGFloat.random(in: -100...100)
        randomX = randomX < 0 ? min(-60, randomX) : max(60, randomX)
        var randomY = CGFloat.random(in: -100...100)
        randomY = randomY < 0 ? min(-60, randomY) : max(60, randomY)

        self.rootNode.addChild(friend)
        let springAnchor = SpringNode()
        self.rootNode.addChild(springAnchor)
        let spring = SKPhysicsJointSpring.joint(
            withBodyA: friend.physicsBody!,
            bodyB: springAnchor.physicsBody!,
            anchorA: friend.position,
            anchorB: springAnchor.position)
        spring.frequency = 0.8
        spring.damping = 0.5
        self.physicsWorld.add(spring)
        friend.position = CGPoint(x: randomX, y: randomY)
    }

    func updateConnections(receivedConnections: Set<Connection>) {
        let connectionsToDelete = self.connections.subtracting(receivedConnections)
        let connectionsToAdd = receivedConnections.subtracting(self.connections)

        self.connections.subtract(connectionsToDelete)
        var nodesToRemove: [SKNode] = []
        for connection in connectionsToDelete {
            if let node = self.rootNode.childNode(withName: connection.friend.id.uuidString) {
                nodesToRemove.append(node)
            }
        }
        self.rootNode.removeChildren(in: nodesToRemove)

        for connection in connectionsToAdd {
            addFriendNode(for: connection)
            self.connections.insert(connection)
        }
    }

    func updateNodeVisuals() {
        for child in rootNode.children {
            guard let friendNode = child as? FriendNode else { continue }
            guard let connection = connections.first(where: { $0.friend.id.uuidString == (friendNode.name ?? "") }) else { continue }
            let state = connection.metaManager.currentRelationshipState
            friendNode.score = connection.metaManager.score
            friendNode.setScale(state.nodeSize / 256.0)
            friendNode.sprite.strokeColor = state.color
            friendNode.orbitRadius = state.orbitRadius
        }
    }

    func filterByName(_ text: String) {
        for child in rootNode.children {
            guard let friendNode = child as? FriendNode else { continue }
            let connection = connections.first { $0.friend.id.uuidString == (friendNode.name ?? "") }
            let visible = text.isEmpty || (connection?.friend.name.localizedCaseInsensitiveContains(text) ?? false)
            friendNode.isHidden = !visible
            friendNode.physicsBody?.isDynamic = visible
            if !visible {
                friendNode.physicsBody?.velocity = .zero
                friendNode.physicsBody?.angularVelocity = 0
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        firstTouch = touch
        let sceneLocation = touch.location(in: self)
        touchStartLocation = sceneLocation
        lastTouchLocation = touch.location(in: self.rootNode)
        touchAngle = self.rootNode.zRotation
        deltaAngle = 0

        touchStartedOnSpiral = nodes(at: sceneLocation).contains { $0.name == "spiral" }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastTouchLocation = touch.location(in: self.rootNode)
        let location = touch.location(in: self.rootNode)
        let tan = (location.x) / (location.y)
        let newAngle = atan(tan)
        let deltaAngle = (newAngle - touchAngle)
        self.rootNode.zRotation -= newAngle
        self.deltaAngle = deltaAngle
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        // se movimento < 10 foi tap
        if touchStartedOnSpiral, let start = touchStartLocation {
            let end = touch.location(in: self)
            let dx = end.x - start.x
            let dy = end.y - start.y
            if sqrt(dx * dx + dy * dy) < 10 {
                onSpiralTapped?()
            }
        }

        if touch == firstTouch {
            firstTouch = nil
            self.pinchDistance = 0
            self.touchAngle = 0
        } else if touch == secondTouch {
            secondTouch = nil
            self.pinchDistance = 0
        }

        touchStartedOnSpiral = false
        touchStartLocation = nil
    }

    override func update(_ currentTime: TimeInterval) {
        for child in self.rootNode.children {
            if let friend = child as? FriendNode {
                friend.update()
            }
        }
    }
}
