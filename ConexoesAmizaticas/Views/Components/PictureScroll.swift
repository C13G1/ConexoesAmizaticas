//
//  PictureScroll.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 22/05/26.
//

import SwiftUI

struct PictureScroll: View {
    var viewModel: FriendFeedViewModel
    var arrowWidth = UIScreen.main.bounds.width * 0.09
    var arrowHeight = UIScreen.main.bounds.height * 0.03
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            
            ForEach(viewModel.posts.indices, id: \.self) { index in
                
                let post = viewModel.posts[index]
                let imageData = post.images.first ?? Data()
                
                GalleryFrame(imageData: imageData)
                    .scaleEffect(viewModel.scaleEffect(index))
                    .zIndex(viewModel.zIndex(index))
                    .rotationEffect(.degrees(viewModel.rotationEffect(index)))
                    .offset(
                        x: viewModel.xOffset(index),
                        y: viewModel.yOffset(index)
                    )
                    .opacity(viewModel.opacity(index))
            }
            
            HStack {
                Image("galleryArrow")
                    .resizable()
                    .frame(width: arrowWidth, height: arrowHeight)
                
                Spacer()
                
                Image("galleryArrow")
                    .resizable()
                    .scaleEffect(x: -1, y: 1)
                    .frame(width: arrowWidth, height: arrowHeight)
            }
            .frame(width: UIScreen.main.bounds.width * 0.78)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    viewModel.onDragChanged(value: value)
                }
                .onEnded { value in
                    viewModel.onDragEnded(value: value)
                }
        )
    }
}

#Preview {
    let mockImage = UIImage(named: "gallery")!
    let mockData = mockImage.pngData() ?? Data()
    let friend = User(name: "nome")
    let conn = Connection(friend: friend)
    
    for i in 0..<5 {
        let post = Post(images: [mockData])
        conn.feedManager.addPost(post)
    }
    
    let viewModel = FriendFeedViewModel(connection: conn)
    
    return PictureScroll(viewModel: viewModel)
}
