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
class CriarPerfilViewModel {
    var modelContext: ModelContext
    var profile: User?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }

    func creatProfile(name: String, image: Image) {
        let renderer = ImageRenderer(content: image)
        if let uiImage = renderer.uiImage {
            let data = uiImage.pngData()
            profile = User.init(name: name, profilePicture: <#T##Image#>)
        }
    }

    func fetchData() {
        do {
            let descriptor = FetchDescriptor<Movie>(sortBy: [SortDescriptor(\.title)])
            movies = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
}
