//
//  MemeViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 05.09.22.
//

import Foundation

struct MemeViewModel {
    
    private var meme: Meme
    
    init(meme: Meme) {
        self.meme = meme
    }
    
    var id: String { meme.id }
    var author: String { meme.author }
    var url: String { meme.url }

}
