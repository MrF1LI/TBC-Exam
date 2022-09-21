//
//  PostViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 07.09.22.
//

import Foundation

protocol PostViewModel {
    var id: String { get }
    var author: String { get }
    var date: Date { get }
    var content: String { get }
}

// MARK: - Post with only text

struct TextPostViewModel: PostViewModel {
    
    private var post: TextPost
    
    init(post: TextPost) {
        self.post = post
    }
    
    var id: String { post.id }
    var author: String { post.author }
    var date: Date { post.date }
    var content: String { post.content }

}

// MARK: - Post with images

struct ImagePostViewModel: PostViewModel {
    
    private var post: ImagePost
    
    init(post: ImagePost) {
        self.post = post
    }
    
    var id: String { post.id }
    var author: String { post.author }
    var date: Date { post.date }
    var content: String { post.content ?? "" }
    var images: [String:String] { post.images }
    
}
