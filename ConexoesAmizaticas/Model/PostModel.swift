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
    var date: Date = Date.now
    var id: UUID = UUID()
    
    init(images: [Data], date: Date = Date.now) {
        self.images = images
        self.date = date
        self.id = UUID()
    }
    
    func appendImageData(_ image: Data) {
        images.append(image)
    }
    
    func deleteDataImage(_ image: Data) {
        images.removeAll(where: {$0 == image})
    }
}
