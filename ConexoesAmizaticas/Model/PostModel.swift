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
    var images: [Data]  = []
    var text:   String? = nil
    var date:   Date    = Date.now
    var id:     UUID    = UUID()
    
    init(images: [Data], text: String? = nil, date: Date = Date.now) {
        self.images = images
        self.text   = text
        self.date   = date
        self.id     = UUID()
    }
    
    func editText(_ newText: String) {
        self.text = newText
    }
    
    func appendImageData(_ image: Data) {
        images.append(image)
    }
    
    func deleteDataImage(_ image: Data) {
        images.removeAll(where: {$0 == image})
    }
}

