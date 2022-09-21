//
//  InfoViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 08.09.22.
//

import Foundation

struct InfoViewModel {
    
    private var info: UserInfo
    
    init(info: UserInfo) {
        self.info = info
    }
    
    var name: String { info.name }
    var image: StudentInfoImage { info.image }
    
}

struct UserViewModel {
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var id: String { user.id }
    var name: String { user.name }
    var surname: String { user.surname }
    var age: Int { user.age }
    var gender: Gender { user.gender }
    var email: String { user.email }
    var course: String { user.course }
    var faculty: String { user.faculty }
    var minor: String { user.minor ?? "" }
    var profile: String { user.profile }
    var chats: [String:Bool] { user.chats ?? [:] }
    
}
