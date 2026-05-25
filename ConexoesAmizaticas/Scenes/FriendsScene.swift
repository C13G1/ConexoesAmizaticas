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
    let connections: [Connection] = [
        Connection(friend: User(profilePicture: UIImage(named: "BrotherdoDesertoAcho")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "DarthVader")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "YodaFantasma")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "C3PO")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "CaraAzul")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "Slavei")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "Careca")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "JarJarBinks")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "BrotherdoDesertoAcho")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "DarthVader")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "YodaFantasma")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "C3PO")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "CaraAzul")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "Slavei")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "Careca")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "JarJarBinks")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
    ]
    var firstTouch: UITouch!
    var secondTouch: UITouch!
    var pinchDistance: Double!
    var touchAngle: CGFloat = 0
    var rootNode: SKNode = SKNode()
    var orbit: Bool
    var orbitaAfastados = OrbitNode(orbitRadius: .afastados)
    var orbitaDistantes = OrbitNode(orbitRadius: .distantes)
    var orbitaEstaveis = OrbitNode(orbitRadius: .estaveis)
    var orbitaProximos = OrbitNode(orbitRadius: .proximos)
    var orbitaInseparaveis = OrbitNode(orbitRadius: .inseparaveis)
    var lastTouchLocation: CGPoint!
    var deltaAngle: Double = 0
    
    init(size: CGSize, orbit: Bool = false) {
        self.orbit = orbit
        super.init(size: size)
        self.backgroundColor = .white
//        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(rootNode)
        initBackground()
        if self.orbit {
            initOrbit()
        }
        initFriends()
        initCamera()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func didMove(to view: SKView) {
//        view.isMultipleTouchEnabled = false
//    }
    
    func initOrbit() {
        self.rootNode.addChild(orbitaAfastados)
        self.rootNode.addChild(orbitaDistantes)
        self.rootNode.addChild(orbitaEstaveis)
        self.rootNode.addChild(orbitaProximos)
        self.rootNode.addChild(orbitaInseparaveis)
    }
    
    func initCamera() {
        let camera = SKCameraNode()
        self.camera = camera
        addChild(camera)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        print("touchedScene")
        firstTouch = touch
        lastTouchLocation = touch.location(in: self.rootNode)
        touchAngle = self.rootNode.zRotation
        deltaAngle = 0
        
        // Lógica de pinch
        //            if let secondTouch = secondTouch {
        //                return
        //            }
        //            else {
        //                secondTouch = touch
        //                print("second touch")
        //                self.pinchDistance = distance(SIMD2(firstTouch.location(in: scene!).x, firstTouch.location(in: scene!).y), SIMD2(secondTouch.location(in: scene!).x, secondTouch.location(in: scene!).y))
        //                print("pinch distance: \(self.pinchDistance ?? 0)")
        //            }
        //        }
        //        else {
        //            firstTouch = touch
        //            print("first touch")
        //        }
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
        print("deltaAngle: \(deltaAngle)")
        print("rotation: \(self.rootNode.zRotation * 180.0 / Double.pi)")
        
        // Lógica de pinch
        //        if let firstTouch = firstTouch, let secondTouch = secondTouch {
        //            self.pinchDistance = distance(SIMD2(firstTouch.location(in: scene!).x, firstTouch.location(in: scene!).y), SIMD2(secondTouch.location(in: scene!).x, secondTouch.location(in: scene!).y))
        //            print("pinch distance: \(self.pinchDistance ?? 0)")
        //        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch == firstTouch {
            firstTouch = nil
            self.pinchDistance = 0
            self.touchAngle = 0
        }
        else if touch == secondTouch {
            secondTouch = nil
            self.pinchDistance = 0
        }
    }
    
    func initBackground() {
        //        let collider = SKShapeNode(path: CGPath(ellipseIn: CGRect(origin: .zero, size: CGSize(width: 1000, height: 1000)), transform: .none), centered: true)
        //        collider.strokeColor = .black
        //        collider.fillColor = .white
        //        collider.physicsBody = SKPhysicsBody(edgeLoopFrom: collider.path!)
        //        //        collider.position = CGPoint(x: rootNode.frame.midX - collider.frame.width / 2, y: rootNode.frame.midY - collider.frame.height / 2)
        //        self.self.rootNode.addChild(collider)
        let spiral = SKSpriteNode(texture: SKTexture(imageNamed: "Spiral"), size: CGSize(width: 122, height: 122))
        spiral.physicsBody = SKPhysicsBody(circleOfRadius: (spiral.size.width - 35) / 2)
        spiral.physicsBody?.affectedByGravity = false
        spiral.physicsBody?.isDynamic = false
        
        self.rootNode.addChild(spiral)
        spiral.run(SKAction.repeatForever(SKAction.rotate(byAngle: -5, duration: 1)))
    }
    
    func initFriends() {
        if orbit {
            for connection in connections {
                let friend = FriendNode(score: connection.metaManager.score, image: connection.friend.profilePicture)
                switch friend.orbitRadius {
                case RelationshipState.afastados.orbitRadius:
                    orbitaAfastados.addFriend(friend: friend)
                case RelationshipState.distantes.orbitRadius:
                    orbitaDistantes.addFriend(friend: friend)
                case RelationshipState.estaveis.orbitRadius:
                    orbitaEstaveis.addFriend(friend: friend)
                case RelationshipState.proximos.orbitRadius:
                    orbitaProximos.addFriend(friend: friend)
                case RelationshipState.inseparaveis.orbitRadius:
                    orbitaInseparaveis.addFriend(friend: friend)
                default:
                    print("vish")
                }
            }
        }
        else {
            for connection in connections {
                let friend = FriendNode(score: connection.metaManager.score, image: connection.friend.profilePicture)
                var randomX = CGFloat.random(in: -100...100)
                if randomX < 0 {
                    randomX = min(-60, randomX)
                }
                else {
                    randomX = max(60, randomX)
                }
                var randomY = CGFloat.random(in: -100...100)
                if randomY < 0 {
                    randomY = min(-60, randomY)
                }
                else {
                    randomY = max(60, randomY)
                }
                friend.position = CGPoint(x: randomX, y: randomY)
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
                print("friend added")
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        for child in self.rootNode.children {
            if let friend = child as? FriendNode {
                friend.update()
            }
            if let orbit = child as? OrbitNode {
                orbit.update()
            }
        }
    }
}
