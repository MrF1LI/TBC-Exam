//
//  Post.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import Foundation

protocol Post: Codable {
    var id: String { get }
    var author: String { get }
    var date: Date { get }
}

enum PostType: String, Codable {
    case text
    case images
    case poll
}

struct PType: Codable {
    let type: PostType
}

//

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

struct Poll: Post, Codable {
    
    struct Option: Codable {
        var id: String
        var content: String
    }
    
    var id: String
    var author: String
    var date: Date
    let question: String
    let options: [String:Option]
    
}
