//
//  er.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI
import Foundation
import SwiftData

class InicialViewModel {
    private(set) var modelContext           : ModelContext
    private(set) var profile                : User?
    private(set) var connectionsWithFriends : [Connection]
    
    init(modelContext: ModelContext) {
        self.modelContext                = modelContext
        self.connectionsWithFriends      = []
        
        fetchData()
    }
    
    func fetchData() {
        do {
            let userDescriptor        = FetchDescriptor<User>(sortBy: [SortDescriptor(\.id)])
            let connectionsDescriptor = FetchDescriptor<Connection>(sortBy: [SortDescriptor(\.id)])
            
            var users                 = try modelContext.fetch(userDescriptor)
            let connection            = try modelContext.fetch(connectionsDescriptor)
            profile                   = users.removeFirst()
            connectionsWithFriends    = connection
        } catch {
            print("Fetch failed")
        }
    }
    
    func getFriends() -> [User] {
        var friends: [User] = []
        
        for connection in connectionsWithFriends {
            friends.append(connection.friend)
        }
        return friends
    }
    
    func convertDataToImage(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
