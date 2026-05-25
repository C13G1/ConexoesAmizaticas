//
//  CriarPerfilViewModel.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 19/05/26.
//

import SwiftData
import Foundation
import SwiftUI

@Observable
class CreatProfileViewModel {
    var modelContext : ModelContext
    var profile      : [User]

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.profile = []
        fetchData()
    }

    func creatProfile(name: String, image: Image) {
        let renderer = ImageRenderer(content: image)
        if let uiImage = renderer.uiImage {
            guard let data = uiImage.pngData()  else{
                print("Error to convert Image to Data")
                return
            }
            profile[0] = User.init(name: name, profilePicture: data)
            modelContext.insert(profile[0])
            fetchData()
        }
    }

    func fetchData() {
        do {
            let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.id)])
            profile = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
}
