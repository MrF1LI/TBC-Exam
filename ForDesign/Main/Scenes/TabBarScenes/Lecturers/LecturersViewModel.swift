//
//  LecturersViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 05.09.22.
//

import Foundation

struct LecturersViewModel {
    
    let firebaseManager: FirebaseManager
    
    init(with firebaseManager: FirebaseManager)  {
        self.firebaseManager = firebaseManager
    }
    
    func getLecturers(completion: @escaping (([LecturerViewModel]) -> Void)) {
        
        firebaseManager.fetchLecturers { arrayOfLecturers in
            let lecturers = arrayOfLecturers.map { LecturerViewModel(lecturer: $0) }
            completion(lecturers)
        }
        
    }
    
}
