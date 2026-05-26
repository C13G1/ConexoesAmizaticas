//
//  VoidScene.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 25/05/26.
//

import SpriteKit

class VoidScene: SKScene {
    var connections: [Connection] = []
    var rootNode = SKNode()
    var orbitaAfastados = OrbitNode(orbitRadius: .afastados)
    var orbitaDistantes = OrbitNode(orbitRadius: .distantes)
    var orbitaEstaveis = OrbitNode(orbitRadius: .estaveis)
    var orbitaProximos = OrbitNode(orbitRadius: .proximos)
    var orbitaInseparaveis = OrbitNode(orbitRadius: .inseparaveis)
    
    init(connections: [Connection]) {
        super.init()
        self.connections = connections
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
                print("vish")
            }
        }
    }
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
