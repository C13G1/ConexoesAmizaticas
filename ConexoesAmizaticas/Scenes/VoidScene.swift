//
//  VoidScene.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 25/05/26.
//

import SpriteKit

/// A specialized visualizer for connections that have fallen into the "vacuum" (vácuo) state due to inactivity.
///
/// Unlike the interactive `FriendsScene`, `VoidScene` automatically organizes neglected friendships into strict,
/// slow-moving orbital rings to emphasize the distance between the user and these contacts.
class VoidScene: SKScene {
    var connections: [Connection] = []
    var rootNode = SKNode()
    
    // Orbital rings categorized by their last known relationship health
    var orbitaAfastados = OrbitNode(orbitRadius: .afastados)
    var orbitaDistantes = OrbitNode(orbitRadius: .distantes)
    var orbitaEstaveis = OrbitNode(orbitRadius: .estaveis)
    var orbitaProximos = OrbitNode(orbitRadius: .proximos)
    var orbitaInseparaveis = OrbitNode(orbitRadius: .inseparaveis)
    
    init(connections: [Connection]) {
        super.init()
        self.connections = connections
        
        // Categorize each neglected connection into its appropriate graphical ring
        for connection in connections {
            let friend = FriendNode(connection: connection)
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
                print("Unknown orbit radius encountered in VoidScene.")
            }
        }
    }
    
    /// Commits the orbital rings to the rendering tree.
    func initOrbit() {
        self.rootNode.addChild(orbitaAfastados)
        self.rootNode.addChild(orbitaDistantes)
        self.rootNode.addChild(orbitaEstaveis)
        self.rootNode.addChild(orbitaProximos)
        self.rootNode.addChild(orbitaInseparaveis)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
