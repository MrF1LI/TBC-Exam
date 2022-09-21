//
//  Post.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import Foundation

// MARK: - Post general

protocol Post: Codable {
    var id: String { get }
    var author: String { get }
    var date: Date { get }
}

enum PostType: String, Codable {
    case text
    case images
}

struct PType: Codable {
    let type: PostType
}

// MARK: - Posts

struct TextPost: Post, Codable {
    var id: String
    var author: String
    var date: Date
    var content: String
}

struct ImagePost: Post, Codable {
    var id: String
    var author: String
    var date: Date
    var content: String?
    var images: [String:String]
}
