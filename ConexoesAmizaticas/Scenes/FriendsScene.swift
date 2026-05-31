//
//  FriendsScene.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit

let MAX_RADIUS: Double = 400
let MIN_RADIUS: Double = 100

/// An interactive physics-based scene representing the user's active social universe.
///
/// `FriendsScene` visualizes `Connection` objects as orbiting planetary nodes around a central hub (the spiral).
/// It handles complex touch gestures like dragging nodes elastically and panning the entire camera view
/// to explore the relationship graph.
class FriendsScene: SKScene {
    var connections: Set<Connection> = Set()
    
    var firstTouch: UITouch!
    var secondTouch: UITouch!
    var pinchDistance: Double!
    var touchOffset: CGFloat = 0
    var rootNode: SKNode = SKNode()
    let sceneType: SceneType!

    /// Triggered when an individual friend node is tapped, routing the user to the profile view.
    var onFriendTapped: ((Connection) -> Void)?
    
    /// Triggered when the central spiral is tapped, routing the user to the "vacuum" (decayed connections) view.
    var onSpiralTapped: (() -> Void)?

    // State trackers to differentiate between a quick tap and a pan/drag gesture.
    private var touchStartedOnSpiral = false
    private var touchStartLocation: CGPoint?

    init(size: CGSize, connections: Set<Connection>, sceneType: SceneType) {
        self.sceneType = sceneType
        super.init(size: size)
        self.connections = connections
        self.backgroundColor = .lightBackground
        self.addChild(rootNode)
        
        if sceneType == .initial {
            initSpiral()
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

    func initSpiral() {
        let spiral = SKSpriteNode(texture: SKTexture(imageNamed: "Spiral"), size: CGSize(width: 122, height: 122))
        spiral.name = "spiral"
        spiral.physicsBody = SKPhysicsBody(circleOfRadius: (spiral.size.width - 10) / 2)
        spiral.physicsBody?.affectedByGravity = false
        spiral.physicsBody?.isDynamic = false
        self.rootNode.addChild(spiral)
    }

    func initFriends() {
        for connection in connections {
            addFriendNode(for: connection)
        }
    }

    /// Spawns a physical node for a connection and tethers it to the center using a spring joint.
    private func addFriendNode(for connection: Connection) {
        let friend = FriendNode(connection: connection)
        friend.onTapped = { [weak self] in
            self?.onFriendTapped?(connection)
        }
        
        // Random initial spawn location to prevent nodes from stacking perfectly on top of each other
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

    /// Synchronizes the graphical nodes with the current state of the database.
    /// Safely adds new friends or removes deleted ones without rebuilding the entire physics simulation.
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

    /// Forces all active nodes to recalculate their size, orbit, and color based on the latest relationship scores.
    func updateNodeVisuals() {
        for child in rootNode.children {
            guard let friendNode = child as? FriendNode else { continue }
            guard let connection = connections.first(where: { $0.friend.id.uuidString == (friendNode.name ?? "") }) else { continue }
            let state = connection.metaManager.currentRelationshipState
            friendNode.score = connection.metaManager.score
            friendNode.setScale(state.nodeSize / 256.0)
            friendNode.sprite.strokeColor = state.color
            friendNode.orbitRadius = state.orbitRadius
            if let image = UIImage(data: connection.friend.profilePicture) {
                friendNode.sprite.fillTexture = SKTexture(image: image.normalized)
            }
        }
    }

    /// Checks whether the given scene-space point lies over the central spiral node.
    /// Allows overlapping friend nodes to forward their touch sequence to the scene so the spiral tap still wins.
    func isTouchOverSpiral(_ sceneLocation: CGPoint) -> Bool {
        nodes(at: sceneLocation).contains { $0.name == "spiral" }
    }

    /// Temporarily hides and freezes nodes that do not match the given search text.
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

    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        firstTouch = touch
        let sceneLocation = touch.location(in: self)
        touchStartLocation = sceneLocation
        let location = touch.location(in: self.rootNode)
        let tan = (location.x) / (location.y)
        touchOffset = atan(tan)

        let touchedNodes = nodes(at: sceneLocation)
        // Só conta como toque na espiral se nenhum FriendNode (nomeado com UUID) estiver sobreposto
        let isFriendNodeTouched = touchedNodes.contains { node in
            guard let name = node.name else { return false }
            return UUID(uuidString: name) != nil
        }
        touchStartedOnSpiral = touchedNodes.contains { $0.name == "spiral" } && !isFriendNodeTouched
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Translates linear finger movement into rotational movement for the entire social graph
        let location = touch.location(in: self.rootNode)
        let tan = (location.x) / (location.y)
        let newAngle = atan(tan)
        let deltaAngle = (newAngle - touchOffset)
        self.rootNode.zRotation -= deltaAngle
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        // Determine if the interaction was a clean tap or a pan/drag
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
            self.touchOffset = 0
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
