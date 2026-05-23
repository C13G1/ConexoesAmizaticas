//
//  FriendFeedViewModel.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 23/05/26.
//

import SwiftUI
import SwiftData
import PhotosUI

@Observable
class FriendFeedViewModel {
    private(set) var connection: Connection
    private(set) var posts: [Post] = []
    
    var selectedItems: [PhotosPickerItem] = []
    var isPickerPresented: Bool = false
    
    var snappedItem: Double = 0
    var draggingItem: Double = 0
    var activeIndex: Int = 0
    
    init(connection: Connection) {
        self.connection = connection
        refreshPosts()
    }
    
    func refreshPosts() {
        self.posts = connection.feedManager.posts.sorted(by: { $0.date > $1.date })
    }
    
    func addPostFromSelection(modelContext: ModelContext) async {
        if !selectedItems.isEmpty {
            var imagesData: [Data] = []
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    imagesData.append(data)
                }
            }
            
            if !imagesData.isEmpty {
                let newPost = Post(images: imagesData)
                connection.feedManager.addPost(newPost)
                modelContext.insert(newPost)
                try? modelContext.save()
                refreshPosts()
            }
            selectedItems = []
        } else {
            return
        }
    }
    
    func deletePost(id: UUID, modelContext: ModelContext) {
        connection.feedManager.deletePost(id: id)
        posts.removeAll(where: { $0.id == id })
        try? modelContext.save()
        refreshPosts()
    }
    
    func distance(_ index: Int) -> Double {
        if !posts.isEmpty {
            return (draggingItem - Double(index)).remainder(dividingBy: Double(posts.count))
        } else {
            return 0
        }
    }
    
    /// Function that determines the radius of the circle
    /// increasing the multiplier will increase the distance
    /// between cards
    func xOffset(_ index: Int) -> Double {
        let angle = Double.pi * 2 / Double(max(posts.count, 1)) * distance(index)
        return sin(angle) * 245
    }
    
    /// Function that defines the arch of the carrousel
    func yOffset(_ index: Int) -> Double {
        let dist = abs(distance(index))
        if dist > 1.5 { return -1000 }
        
        return -pow(dist * 30, 2) / 10
    }
    
    /// Function that determines the angle of the lateral
    /// cards on the carrousel
    func rotationEffect(_ index: Int) -> Double {
        let dist = distance(index)
        return -dist * 30
    }
    
    func zIndex(_ index: Int) -> Double {
        1.0 - abs(distance(index)) * 0.1
    }
    
    func scaleEffect(_ index: Int) -> Double {
        1.0 - abs(distance(index)) * 0.2
    }
    
    /// Function that determines the opacity of the cards
    /// making the cards that are not in the center or
    /// sideways invisible
    func opacity(_ index: Int) -> Double {
        let dist = abs(distance(index))
        return dist > 1.5 ? 0.0 : 1.0
    }
    
    func onDragChanged(value: DragGesture.Value) {
        draggingItem = snappedItem + value.translation.width / 500
    }
    
    func onDragEnded(value: DragGesture.Value) {
        withAnimation {
            draggingItem = snappedItem + value.predictedEndTranslation.width / 350
            
            let postsCount = Double(max(posts.count, 1))
            draggingItem = round(draggingItem).remainder(dividingBy: postsCount)
            snappedItem = draggingItem
            
            let count = posts.count
            activeIndex = count + Int(draggingItem)
            if activeIndex > count || Int(draggingItem) >= 0 {
                activeIndex = Int(draggingItem)
            }
        }
    }
    
    func uiImage(from data: Data) -> UIImage? {
        UIImage(data: data)
    }
}
