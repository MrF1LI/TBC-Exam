//
//  Message.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 13.09.22.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: String
    var sender: String
    var content: String
    var date: Date
}
