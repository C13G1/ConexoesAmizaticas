//
//  PostTests.swift
//  ConexoesAmizaticas
//
//  Created by Dayô Araújo on 18/05/26.
//

import SwiftUI
import Testing
@testable import ConexoesAmizaticas

struct PostTests {
    var images: [Image] = [Image("image1"), Image("image2")]
    var post: Post {
        Post(images: images, text: "Text", date: Date.now)
    }
    
    @Test func editTextWithSuccessTest() {
        let sut = post
        sut.editText("Updated Text")
        
        #expect(sut.text == "Updated Text")
    }
    
    @Test func appendImageWithSuccessTest() {
        let sut = post
        sut.appendImage(Image("image3"))
        
        #expect(sut.images == [Image("image1"), Image("image2"), Image("image3")])
    }
    
    @Test func deleteImageWithSuccessTest() {
        let sut = post
        sut.deleteImage(Image("image3"))
        
        #expect(sut.images == [Image("image1"), Image("image2")])
    }
}
