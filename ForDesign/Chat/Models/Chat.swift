//
//  Chat.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 11.09.22.
//

import Foundation

struct Chat: Identifiable, Codable {
    
    enum ChatType: String, Codable {
        case personal
        case group
    }
    
    var id: String
    var members: [String:Bool]
    var type: ChatType?
    var lastMessage: Message?
    
    func getMemberIds() -> [String] {
        members.map { $0.key }
    }
    
}
