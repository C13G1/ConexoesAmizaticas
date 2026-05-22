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
    var centerScene: CGPoint!
    var rootNode: SKNode = SKNode()
    var orbit: Bool
    var testNode: FriendNode!
    var orbitaConhecido = OrbitNode(orbitRadius: .conhecido)
    var orbitaAmigo = OrbitNode(orbitRadius: .amigo)
    var orbitaAmigoProximo = OrbitNode(orbitRadius: .amigoProximo)
    var orbitaMelhorAmigo = OrbitNode(orbitRadius: .melhorAmigo)
    
    init(size: CGSize, orbit: Bool = false) {
        self.orbit = orbit
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.8)
        self.addChild(rootNode)
        initBackground()
        if self.orbit {
            initOrbit()
        }
        else {
            initAttractor()
        }
        initFriends()
        initCamera()
//        initTest()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        self.centerScene = CGPoint(x: frame.midX, y: frame.midY)
        view.isMultipleTouchEnabled = false
    }
    
    func initAttractor() {
        
    }
    
    func initOrbit() {
        self.rootNode.addChild(orbitaConhecido)
        self.rootNode.addChild(orbitaAmigo)
        self.rootNode.addChild(orbitaAmigoProximo)
        self.rootNode.addChild(orbitaMelhorAmigo)
    }
    
    func initCamera() {
        let camera = SKCameraNode()
        self.camera = camera
        if self.orbit {
            camera.position = CGPoint(x: frame.midX, y: frame.midY + 500)
        }
        else {
            camera.position = CGPoint(x: frame.midX, y: frame.midY + 300)
        }
        addChild(camera)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        print("touchedScene")
        firstTouch = touch
        let location = touch.location(in: self)
        let tan = (location.x - centerScene.x) / (location.y - centerScene.y)
        touchAngle = atan(tan)
        
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
        let location = touch.location(in: self)
        let tan = (location.x - centerScene.x) / (location.y - centerScene.y)
        let newAngle = atan(tan)
        let deltaAngle = (touchAngle - newAngle) / 10
//        print("\(deltaAngle)")
        self.rootNode.zRotation += deltaAngle
        
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
        let collider = SKShapeNode(path: CGPath(ellipseIn: CGRect(origin: .zero, size: CGSize(width: 1000, height: 1000)), transform: .none), centered: true)
        collider.strokeColor = .black
        collider.fillColor = .white
        collider.physicsBody = SKPhysicsBody(edgeLoopFrom: collider.path!)
        //        collider.position = CGPoint(x: rootNode.frame.midX - collider.frame.width / 2, y: rootNode.frame.midY - collider.frame.height / 2)
        self.self.rootNode.addChild(collider)
        var blackHole = SKShapeNode()
        if orbit {
            blackHole = SKShapeNode(circleOfRadius: 40)
            blackHole.fillColor = .black
            blackHole.glowWidth = 10
            blackHole.strokeColor = .black
        }
        else {
            blackHole = SKShapeNode(circleOfRadius: 30)
        }
        blackHole.fillColor = .black
        self.self.rootNode.addChild(blackHole)
    }
    
    func initFriends() {
        if orbit {
            for connection in connections {
                let friend = FriendNode(score: connection.metaManager.score, image: connection.friend.profileImage)
                switch friend.orbitRadius {
                case .conhecido:
                    orbitaConhecido.addFriend(friend: friend)
                case .amigo:
                    orbitaAmigo.addFriend(friend: friend)
                case .amigoProximo:
                    orbitaAmigoProximo.addFriend(friend: friend)
                case .melhorAmigo:
                    orbitaMelhorAmigo.addFriend(friend: friend)
                }
                print("friend added")
            }
        }
        else {
            for connection in connections {
                let friend = FriendNode(score: connection.metaManager.score, image: connection.friend.profileImage)
                friend.position = CGPoint(x: frame.midX + CGFloat.random(in: 1...10), y: frame.midY + CGFloat.random(in: 1...10))
            self.self.rootNode.addChild(friend)
            print("friend added")
            }
        }
    }
    
    func initTest() {
        self.testNode = FriendNode(score: connections[0].metaManager.score, image: connections[0].friend.profileImage)
        testNode.position = CGPoint(x: 0, y: +200)
        self.rootNode.addChild(testNode)
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
