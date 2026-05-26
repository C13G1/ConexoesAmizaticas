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
    var connections: [Connection] = []
    var firstTouch: UITouch!
    var secondTouch: UITouch!
    var pinchDistance: Double!
    var touchAngle: CGFloat = 0
    var rootNode: SKNode = SKNode()
    var lastTouchLocation: CGPoint!
    var deltaAngle: Double = 0
    
    init(size: CGSize, connections: [Connection]) {
        super.init(size: size)
        self.connections = connections
        self.backgroundColor = .lightBackground
        self.addChild(rootNode)
        initBackground()
        initFriends()
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
        spiral.physicsBody = SKPhysicsBody(circleOfRadius: (spiral.size.width - 35) / 2)
        spiral.physicsBody?.affectedByGravity = false
        spiral.physicsBody?.isDynamic = false
        
        self.rootNode.addChild(spiral)
        spiral.run(SKAction.repeatForever(SKAction.rotate(byAngle: -1, duration: 1)))
    }
    
    func initFriends() {
        for connection in connections {
            let friend = FriendNode(connection: connection)
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
    
    override func update(_ currentTime: TimeInterval) {
        for child in self.rootNode.children {
            if let friend = child as? FriendNode {
                friend.update()
            }
        }
    }
}
