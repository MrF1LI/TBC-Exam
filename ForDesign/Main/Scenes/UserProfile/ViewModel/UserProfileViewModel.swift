//
//  UserProfileViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 10.09.22.
//

import Foundation

struct UserProfileViewModel {
    
    let firebaseManager: FirebaseManager
    
    init(with firebaseManager: FirebaseManager)  {
        self.firebaseManager = firebaseManager
    }
    
    func getUserInfo(completion: @escaping (([InfoViewModel], UserViewModel) -> Void)) {
        
        firebaseManager.fetchUserInfo(by: FirebaseManager.currentUser!.uid) { user, userInfo in
            let userInfo = userInfo.map { InfoViewModel(info: $0) }
            let userViewModel = UserViewModel(user: user)
            completion(userInfo, userViewModel)
        }
        
    }
    
}
