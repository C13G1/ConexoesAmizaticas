//
//  PictureScroll.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 22/05/26.
//

import SwiftUI
import SwiftData

struct PictureScroll: View {
    var viewModel: FriendFeedViewModel
    var arrowWidth = UIScreen.main.bounds.width * 0.09
    var arrowHeight = UIScreen.main.bounds.height * 0.03
    var frameWidth = UIScreen.main.bounds.width * 0.45
    var frameHeight = UIScreen.main.bounds.height * 0.25
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            
            if viewModel.posts.isEmpty {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(style: StrokeStyle(lineWidth: 5, dash: [8]))
                    .foregroundStyle(.gray.opacity(0.5))
                    .frame(width: frameWidth, height: frameHeight)
            } else {
                ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, post in
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
                        .onTapGesture {
                            withAnimation {
                                viewModel.postToDelete = post
                            }
                        }
                }
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
