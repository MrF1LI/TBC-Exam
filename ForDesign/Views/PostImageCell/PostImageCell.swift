//
//  PostImageCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 25.08.22.
//

import UIKit

class PostImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewPostImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with imageUrl: String) {
        imageViewPostImage.sd_setImage(with: URL(string: imageUrl),
                                     placeholderImage: UIImage(named: "photo"),
                                     options: .continueInBackground,
                                     completed: nil)
    }

}
