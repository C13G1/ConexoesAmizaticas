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
class PostModel {
    var images: [Data] = []
    var text: String? = nil
    var date: Date = Date.now
    var id: UUID = UUID()
    
    init(images: [Data], text: String? = nil, date: Date = Date.now) {
        self.images = images
        self.text = text
        self.date = date
        self.id = UUID()
    }
}

class Post: Identifiable {
    var images: [Image] = []
    var text: String? = nil
    var date: Date = Date.now
    var id: UUID = UUID()
    
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

