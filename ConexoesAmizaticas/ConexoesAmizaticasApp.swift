//
//  ConexoesAmizaticasApp.swift
//  ConexoesAmizaticas
//
//  Created by Enzo Ferroni on 14/05/26.
//

import SwiftUI
import SwiftData
import Aptabase

@main
struct ConexoesAmizaticasApp: App {
    
    init() {
        Aptabase.shared.initialize(appKey: "A-US-8865447669")
        Aptabase.shared.trackEvent("app_started")
        NotificationManager.requestPermission()
        ProximityNotifier.shared.start()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Post.self,
            FeedManager.self,
            Connection.self,
            MetaManager.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
