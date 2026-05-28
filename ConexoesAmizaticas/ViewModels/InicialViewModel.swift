//
//  InicialViewModel.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 20/05/26.
//

import SwiftUI
import Foundation
import SwiftData

/// The central source of truth for the application's root state.
///
/// `InicialViewModel` manages the active user profile and oversees the comprehensive list of their
/// social connections. It serves as the primary data provider for the root navigational structures
/// (like `InitialView` and `TabBar`) and handles initial data fetching from SwiftData on launch.
@Observable
class InicialViewModel {
    private(set) var modelContext           : ModelContext!
    private(set) var profile                : User = User()
    
    /// The master list of all connections. Currently pre-populated with mock data for demonstration purposes.
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
    
    /// Pulls the primary user and all active connections from local persistence.
    func fetchData() {
        do {
            let userDescriptor        = FetchDescriptor<User>()
            let connectionsDescriptor = FetchDescriptor<Connection>()
            
            var users                 = try modelContext.fetch(userDescriptor)
            let connections           = try modelContext.fetch(connectionsDescriptor)
            guard users.count > 0 else { return }
            profile                   = users.removeFirst()
            connectionsWithFriends    = connections
        } catch {
            print("Fetch failed")
        }
    }
    
    /// Extracts a flat array of `User` profiles from the complex `Connection` models.
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
    
    /// Retrieves a specific persistent connection based on the friend's unique user identifier.
    func getConnectionByFriend(friend: User) -> Connection? {
        for c in connectionsWithFriends {
            if c.friend.id == friend.id {
                return c
            }
        }
        return nil
    }
}
