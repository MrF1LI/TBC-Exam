//
//  ImageCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 03.09.22.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with image: UIImage) {
        imageViewImage.image = image
    }

}
