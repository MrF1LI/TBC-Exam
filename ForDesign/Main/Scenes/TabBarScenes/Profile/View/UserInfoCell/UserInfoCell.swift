//
//  UserInfoCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class UserInfoCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelInfo: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Functions
    
    func configure(with viewModel: InfoViewModel) {
        imageViewIcon.image = UIImage(named: viewModel.image.rawValue)
        labelInfo.text = viewModel.name
    }
    
}
