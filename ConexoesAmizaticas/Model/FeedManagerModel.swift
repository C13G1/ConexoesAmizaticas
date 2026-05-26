//
//  FeedManagerModel.swift
//  ConexoesAmizaticas
//
//  Created by Thomas Pinheiro Grandin on 18/05/26.
//

import Foundation
import SwiftData

@Model
class FeedManager {
    private(set) var posts: [Post] = []
    
    init(){}
    
    func addPost(_ post: Post) {
        posts.append(post)
    }
    
    func deletePost(id: UUID) {
        posts.removeAll(where: {$0.id == id})
    }
}
