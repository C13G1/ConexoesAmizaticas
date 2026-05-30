//
//  PostTests.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 28/05/26.
//


import Testing
import Foundation
@testable import ConexoesAmizaticas

struct PostTests {

    @Test("Init armazena imagens e data")
    func initStoresImagesAndDate() {
        let images = [Data([0x01]), Data([0x02])]
        let date = Date(timeIntervalSince1970: 1_000_000)
        let post = Post(images: images, date: date)

        #expect(post.images == images)
        #expect(post.date == date)
    }

    @Test("Init gera um UUID único para cada post")
    func initGeneratesUniqueID() {
        let post1 = Post(images: [])
        let post2 = Post(images: [])
        #expect(post1.id != post2.id)
    }

    @Test("appendImageData adiciona imagem à lista")
    func appendImageDataAddsImage() {
        let post = Post(images: [])
        let image = Data([0xAB])
        post.appendImageData(image)

        #expect(post.images.count == 1)
        #expect(post.images.first == image)
    }

    @Test("appendImageData permite imagens duplicadas")
    func appendImageDataAllowsDuplicates() {
        let post = Post(images: [])
        let image = Data([0x10])
        post.appendImageData(image)
        post.appendImageData(image)

        #expect(post.images.count == 2)
    }

    @Test("deleteDataImage remove imagem correspondente")
    func deleteDataImageRemovesMatching() {
        let img1 = Data([0x01])
        let img2 = Data([0x02])
        let post = Post(images: [img1, img2])

        post.deleteDataImage(img1)

        #expect(post.images.count == 1)
        #expect(post.images.first == img2)
    }

    @Test("deleteDataImage remove todas ocorrências duplicadas")
    func deleteDataImageRemovesAllDuplicates() {
        let img = Data([0x05])
        let post = Post(images: [img, img, Data([0x99])])

        post.deleteDataImage(img)

        #expect(post.images.count == 1)
        #expect(post.images.first == Data([0x99]))
    }

    @Test("deleteDataImage com imagem inexistente não altera lista")
    func deleteDataImageNonexistentIsNoOp() {
        let img = Data([0x01])
        let post = Post(images: [img])

        post.deleteDataImage(Data([0xFF]))

        #expect(post.images.count == 1)
        #expect(post.images.first == img)
    }
}
