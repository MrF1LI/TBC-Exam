//
//  Review.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 21.08.22.
//

import Foundation

struct Review: Codable {
    let id: String
    let author: String
    let text: String
    let date: Date
    
    var lecturer: String?
}
