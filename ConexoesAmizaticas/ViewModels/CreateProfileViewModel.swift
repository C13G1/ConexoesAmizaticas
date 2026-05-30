//
//  CreateProfileViewModel.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 19/05/26.
//

import SwiftData
import Foundation
import SwiftUI

/// Handles the onboarding flow and creation of the primary user's profile.
///
/// This ViewModel isolates the SwiftData insert operations required when the user first opens the app,
/// converting SwiftUI images to raw byte data before persisting it to the database.
@Observable
class CreateProfileViewModel {
    var modelContext : ModelContext
    var profile      : [User]

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.profile = []
        fetchData()
    }

    /// Generates and persists the root user profile.
    /// - Parameters:
    ///   - name: The display name chosen by the user.
    ///   - image: The SwiftUI image selected via the onboarding picker.
    func createProfile(name: String, image: Image) {
        let renderer = ImageRenderer(content: image)
        if let uiImage = renderer.uiImage {
            guard let data = uiImage.pngData()  else{
                print("Error to convert Image to Data")
                return
            }
            // Ensures we always update the primary profile (index 0)
            profile[0] = User.init(name: name, profilePicture: data)
            modelContext.insert(profile[0])
            fetchData()
        }
    }

    /// Retrieves the current profile from the local SwiftData store.
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.id)])
            profile = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
}
