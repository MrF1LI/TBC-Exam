//
//  User.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let surname: String
    let age: Int
    let email: String
    let gender: Gender
    let profile: String
    let date: String
    
    let course: String
    let faculty: String
    let minor: String?
    
    let chats: [String]?
}

enum Gender: String, Codable {
    case male
    case female
}

//

struct UserInfo {
    var name: String
    var image: StudentInfoImage
}

enum StudentInfoImage: String {
    case age = "user"
    case faculty, course, minor
}
