//
//  ReviewViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 06.09.22.
//

import Foundation

struct ReviewViewModel {
    
    private var review: Review
    
    init(review: Review) {
        self.review = review
    }
    
    var id: String { review.id }
    var author: String { review.author }
    var date: Date { review.date }
    var text: String { review.text }
    
    var lecturer: String {
        get { review.lecturer ?? "" }
        set { review.lecturer = newValue }
    }
    
}
