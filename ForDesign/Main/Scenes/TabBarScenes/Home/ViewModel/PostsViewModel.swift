//
//  PostsViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 07.09.22.
//

import Foundation

struct PostsViewModel {
    
    let firebaseManager: FirebaseManager
    
    init(with firebaseManager: FirebaseManager)  {
        self.firebaseManager = firebaseManager
    }
    
    func getPosts(completion: @escaping (([PostViewModel]) -> Void)) {
        
        firebaseManager.fetchPosts { arrayOfPosts in
            
            let posts: [PostViewModel] = arrayOfPosts.map { post in
                            
                if post is TextPost {
                    return TextPostViewModel(post: post as! TextPost)
                } else if post is ImagePost {
                    return ImagePostViewModel(post: post as! ImagePost)
                } else {
                    return nil
                }
                
            }.compactMap { $0 }
            
            completion(posts)
            
        }
        
    }
    
}
