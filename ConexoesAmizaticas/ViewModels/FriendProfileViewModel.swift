//
//  FriendProfileViewModel.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import Foundation
import SwiftUI
import SwiftData

class FriendProfileViewModel {
    private(set) var connection: Connection
    
    init(connection: Connection) {
        self.connection = connection
    }
    
    func defineMeta(meta: RelationshipState){
        connection.metaManager.setMeta(meta)
    }
}
