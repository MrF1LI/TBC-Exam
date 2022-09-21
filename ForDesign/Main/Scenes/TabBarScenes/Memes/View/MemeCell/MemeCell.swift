//
//  MemeCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 25.08.22.
//

import UIKit

class MemeCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Functions
    
    func configure(with viewModel: MemeViewModel) {
        imageViewMeme.sd_setImage(with: URL(string: viewModel.url),
                                  placeholderImage: UIImage(named: "picture"),
                                  options: .continueInBackground,
                                  completed: nil)
    }

}
