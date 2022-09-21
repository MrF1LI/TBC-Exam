//
//  CommentCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 29.08.22.
//

import UIKit

class CommentCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageViewAuthorProfile: UIImageView!
    @IBOutlet weak var labelAuthorFullName: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var viewCommentBackground: UIView!
    
    // MARK: - Variables
    
    private let radius: CGFloat = 25
    
    // MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Functions
    
    private func configureDesign() {
        viewCommentBackground.layer.cornerRadius = radius
        imageViewAuthorProfile.setCornerStyle(.capsule)
    }
    
    func configure(with viewModel: CommentViewModel) {
        
        labelContent.text = viewModel.content
        labelDate.text = viewModel.date.timeAgoDisplay()
        
        FirebaseManager.shared.fetchUserInfo(by: viewModel.author) { user, userInfo in
            self.labelAuthorFullName.text = "\(user.name) \(user.surname)"
            
            self.imageViewAuthorProfile.sd_setImage(with: URL(string: user.profile),
                                                    placeholderImage: UIImage(named: "user"),
                                                    options: .continueInBackground,
                                                    completed: nil)
        }
        
    }
    
}
