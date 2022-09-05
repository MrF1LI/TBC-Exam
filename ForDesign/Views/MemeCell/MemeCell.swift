//
//  MemeCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 25.08.22.
//

import UIKit

class MemeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with meme: Meme) {
        
        imageViewMeme.sd_setImage(with: URL(string: meme.url),
                                  placeholderImage: UIImage(named: "picture"),
                                  options: .continueInBackground,
                                  completed: nil)
        
    }

}
