//
//  FriendsScene.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 20/05/26.
//

import SpriteKit

class FriendsScene: SKScene {
    let connections: [Connection] = [Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100)),
                                     Connection(friend: User(), score: Double.random(in: 1...100))]
    var centerAnchor: AnchorPoint!
    
    override init() {
        super.init()
        self.centerAnchor = AnchorPoint(x: Int16(frame.midX), y: Int16(frame.midY))
        initFriends()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {return}
//        let friend = FriendNode(connection: Connection(friend: User()))
//        friend.position = touch.location(in: self)
//    }
    
    func initFriends() {
        for connection in connections {
            addFriend(friend: FriendNode(connection: connection))
        }
    }
    
    func addFriend(friend: FriendNode) {
        friend.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(friend)
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
