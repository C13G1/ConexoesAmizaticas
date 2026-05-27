//
//  er.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI
import Foundation
import SwiftData

@Observable
class InicialViewModel {
    private(set) var modelContext           : ModelContext!
    private(set) var profile                : User?
    private(set) var connectionsWithFriends : [Connection] = [
        Connection(friend: User(name: "BrotherdoDesertoAcho", profilePicture: UIImage(named: "BrotherdoDesertoAcho")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(name: "DarthVader", profilePicture: UIImage(named: "DarthVader")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(name: "YodaFantasma", profilePicture: UIImage(named: "YodaFantasma")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100)),
        Connection(friend: User(name: "C3PO", profilePicture: UIImage(named: "C3PO")!.jpegData(compressionQuality: 1)!), score:
            Double.random(in: 10...100)),
        Connection(friend: User(name: "CaraAzul", profilePicture: UIImage(named: "CaraAzul")!.jpegData(compressionQuality: 1)!), score:
            Double.random(in: 10...100)),
        Connection(friend: User(name: "Slavei", profilePicture: UIImage(named: "Slavei")!.jpegData(compressionQuality: 1)!), score:
            Double.random(in: 10...100)),
        Connection(friend: User(name: "Careca", profilePicture: UIImage(named: "Careca")!.jpegData(compressionQuality: 1)!), score:
            Double.random(in: 10...100)),
        Connection(friend: User(name: "JarJarBinks", profilePicture: UIImage(named: "JarJarBinks")!.jpegData(compressionQuality: 1)!), score: Double.random(in: 10...100))]
    
    func fetchData() {
        do {
            let userDescriptor        = FetchDescriptor<User>(/*sortBy: [SortDescriptor(\.id)]*/)
            let connectionsDescriptor = FetchDescriptor<Connection>(/*sortBy: [SortDescriptor(\.id)]*/)
            
            var users                 = try modelContext.fetch(userDescriptor)
            let connections           = try modelContext.fetch(connectionsDescriptor)
            guard users.count > 0 else { return }
            profile                   = users.removeFirst()
            connectionsWithFriends    = connections
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
    
    func setModelContext(modelContext: ModelContext){
        self.modelContext = modelContext
    }
    
    func getConnectionByFriend(friend: User) -> Connection?{
        for c in connectionsWithFriends{
            if c.friend.id == friend.id{
                return c
            }
        }
        return nil
    }
}
