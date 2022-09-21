//
//  MemesViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 05.09.22.
//

import Foundation

struct MemesViewModel {
    
    let firebaseManager: FirebaseManager
    
    init(with firebaseManager: FirebaseManager)  {
        self.firebaseManager = firebaseManager
    }
    
    func getMemes(completion: @escaping (([MemeViewModel]) -> Void)) {
        
        firebaseManager.fetchMemes { arrayOfMemes in
            let memes = arrayOfMemes.map { MemeViewModel(meme: $0) }
            completion(memes)
        }
        
    }
    
}
