//
//  CommentCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 29.08.22.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var imageViewAuthorProfile: UIImageView!
    @IBOutlet weak var labelAuthorFullName: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var viewCommentBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDesign() {
        viewCommentBackground.layer.cornerRadius = 25
        imageViewAuthorProfile.setCornerStyle(.capsule)
    }
    
    func configure(with comment: Comment) {
        
        labelContent.text = comment.content
        
        FirebaseManager.shared.fetchUserInfo(by: comment.author) { user, userInfo in
            self.labelAuthorFullName.text = "\(user.name) \(user.surname)"
            
            self.imageViewAuthorProfile.sd_setImage(with: URL(string: user.profile),
                                                    placeholderImage: UIImage(named: "user"),
                                                    options: .continueInBackground,
                                                    completed: nil)
        }
        
    }
    
}
