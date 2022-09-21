//
//  ReviewsViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 06.09.22.
//

import Foundation

struct ReviewsViewModel {
    
    let firebaseManager: FirebaseManager
    
    init(with firebaseManager: FirebaseManager)  {
        self.firebaseManager = firebaseManager
    }
        
    func getReviews(of lecturer: Lecturer, completion: @escaping (([ReviewViewModel]) -> Void)) {
        
        firebaseManager.fetchReviews(of: lecturer) { arrayOfReviews in
            let reviews = arrayOfReviews.map { ReviewViewModel(review: $0) }
            completion(reviews)
        }
        
    }
    
    // MARK: - Add new review
    
    func review(lecturer: Lecturer, with review: String, completion: @escaping () -> Void) {
        FirebaseManager.shared.review(lecturer: lecturer, with: review) {
            completion()
        }
    }
    
}
