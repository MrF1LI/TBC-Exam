//
//  CommentsViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 06.09.22.
//

import Foundation

struct CommentsViewModel {
    
    let firebaseManager: FirebaseManager
    
    init(with firebaseManager: FirebaseManager)  {
        self.firebaseManager = firebaseManager
    }
    
    func getComments(of post: PostViewModel, completion: @escaping (([CommentViewModel]) -> Void)) {
        firebaseManager.fetchComments(of: post) { arrayOfComments in
            let comments = arrayOfComments.map { CommentViewModel(comment: $0) }
            completion(comments)
        }
    }

    func comment(post: PostViewModel, with comment: String, completion: @escaping () -> Void) {
        FirebaseManager.shared.comment(post: post, with: comment) {
            completion()
        }
    }
    
}
