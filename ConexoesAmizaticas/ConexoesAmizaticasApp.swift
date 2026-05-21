//
//  ConexoesAmizaticasApp.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 14/05/26.
//

import SwiftUI
import SwiftData

@main
struct ConexoesAmizaticasApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Post.self,
            FeedManager.self,
            Connection.self,
            MetaManager.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FriendTestView()
        }
        .modelContainer(sharedModelContainer)
    }
}
