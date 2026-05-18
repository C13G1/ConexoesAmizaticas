//
//  PostModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Post: Identifiable {
    var images: [Image]
    var text: String?
    var date: Date
    var id: UUID
    
    init(images: [Image], text: String? = nil, date: Date = Date.now) {
        self.images = images
        self.text = text
        self.date = date
        self.id = UUID()
    }
    
    func editText(_ newText: String) {
        self.text = newText
    }
    
    func appendImage(_ image: Image) {
        images.append(image)
    }
    
    func deleteImage(_ image: Image) {
        images.removeAll(where: {$0 == image})
    }
}

