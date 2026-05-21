//
//  FriendsScene.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit

class FriendsScene: SKScene {
    let connections: [Connection] = [
        Connection(friend: User(profilePicture: UIImage(named: "BrotherdoDesertoAcho")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "DarthVader")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "YodaFantasma")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "C3PO")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "CaraAzul")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "Slavei")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "Careca")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(profilePicture: UIImage(named: "JarJarBinks")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),]
    var firstTouch: UITouch!
    var secondTouch: UITouch!
    var pinchDistance: Double!
    var lastTouchLocation: CGPoint!
    
    override init(size: CGSize) {
        super.init(size: size)
        initColliders()
        initFriends()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if let firstTouch = firstTouch {
            if let secondTouch = secondTouch {
                return
            }
            else {
                secondTouch = touch
                print("second touch")
                self.pinchDistance = distance(SIMD2(firstTouch.location(in: scene!).x, firstTouch.location(in: scene!).y), SIMD2(secondTouch.location(in: scene!).x, secondTouch.location(in: scene!).y))
                print("pinch distance: \(self.pinchDistance ?? 0)")
            }
        }
        else {
            firstTouch = touch
            print("first touch")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = firstTouch, let secondTouch = secondTouch {
            self.pinchDistance = distance(SIMD2(firstTouch.location(in: scene!).x, firstTouch.location(in: scene!).y), SIMD2(secondTouch.location(in: scene!).x, secondTouch.location(in: scene!).y))
            print("pinch distance: \(self.pinchDistance ?? 0)")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch == firstTouch {
            firstTouch = nil
            self.pinchDistance = 0
        }
        else if touch == secondTouch {
            secondTouch = nil
            self.pinchDistance = 0
        }
    }
    
    func initColliders() {
        let collider = SKShapeNode(circleOfRadius: 400)
        collider.strokeColor = .black
        collider.fillColor = .white
        collider.physicsBody = SKPhysicsBody(edgeLoopFrom: collider.path!)
        
        collider.position = CGPoint(x: frame.midX, y: frame.midY - 200)
        addChild(collider)
    }
    
    func initFriends() {
        for connection in connections {
            addFriend(friend: FriendNode(connection: connection))
        }
    }
    
    func addFriend(friend: FriendNode) {
        friend.position = CGPoint(x: frame.midX + CGFloat.random(in: 1...10), y: frame.midY + CGFloat.random(in: 1...10))
        
        let anchor: SpringNode = SpringNode()
        anchor.position = CGPoint(x: frame.midX, y: frame.midY)
        let spring = SKPhysicsJointSpring.joint(withBodyA: friend.physicsBody!,
                                                bodyB: anchor.physicsBody!,
                                                anchorA: friend.position,
                                                anchorB: anchor.position)
        spring.frequency = 0.8
        spring.damping = 0.5
        let rootNode = SKNode()
        rootNode.addChild(friend)
        rootNode.addChild(anchor)
        addChild(rootNode)
        physicsWorld.add(spring)
        
        print("friend added")
    }
    
    override func update(_ currentTime: TimeInterval) {
        for child in self.children {
            if let friend = child as? FriendNode {
                friend.update()
            }
        }
    }
}
