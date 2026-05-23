//
//  ProfileFeedViewModel.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 23/05/26.
//

import SwiftUI
import SwiftData
import PhotosUI

@Observable
class ProfileFeedViewModel {
    private(set) var modelContext: ModelContext
    private(set) var feedManager: FeedManager?
    private(set) var posts: [Post] = []
    
    var selectedItems: [PhotosPickerItem] = []
    var isPickerPresented: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }
    
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.id)])
            let users = try modelContext.fetch(descriptor)
            
            guard let currentUser = users.first else { return }
            let feedDescriptor = FetchDescriptor<FeedManager>()
            let managers = try modelContext.fetch(feedDescriptor)
            
            if let manager = managers.first {
                self.feedManager = manager
            } else {
                let newManager = FeedManager()
                modelContext.insert(newManager)
                try modelContext.save()
                self.feedManager = newManager
            }
            
            refreshPosts()
        } catch {
            print("falha ao buscar feed manager")
        }
    }
    
    func refreshPosts() {
        guard let manager = feedManager else { return }
        self.posts = manager.posts.sorted(by: { $0.date > $1.date })
    }
    
    func addPostFromSelection() async {
        if !selectedItems.isEmpty {
            var imagesData: [Data] = []
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    imagesData.append(data)
                }
            }
            
            if !imagesData.isEmpty {
                let newPost = Post(images: imagesData)
                feedManager?.addPost(newPost)
                modelContext.insert(newPost)
                try? modelContext.save()
                refreshPosts()
            }
            selectedItems = []
        } else {
            return
        }
    }
    
    func deletePost(id: UUID) {
        feedManager?.deletePost(id: id)
        posts.removeAll(where: { $0.id == id })
        try? modelContext.save()
    }
        
    func uiImage(from data: Data) -> UIImage? {
        UIImage(data: data)
    }
}
