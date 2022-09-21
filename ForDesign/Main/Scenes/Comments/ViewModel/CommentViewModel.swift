//
//  CommentViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 06.09.22.
//

import Foundation

struct CommentViewModel {
    
    private var comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    var id: String { comment.id }
    var author: String { comment.author }
    var content: String { comment.content }
    var date: Date { comment.date }
    
}
