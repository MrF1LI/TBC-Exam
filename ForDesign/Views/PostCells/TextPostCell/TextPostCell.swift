//
//  TextPostCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class TextPostCell: UITableViewCell {
    
    // MARK: Variables
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelCourseAndFaculty: UILabel!
    
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var imageViewReact: UIImageView!
    @IBOutlet weak var imageViewComment: UIImageView!
    @IBOutlet weak var imageViewShare: UIImageView!
    
    var delegate: PostCellDelegate!

    // MARK: Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureDesign()
        configureGestures()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: Functions
    
    func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 35
        contentView.layer.masksToBounds = true
    }
    
    func configureGestures() {
        let gestureShowProfile = UITapGestureRecognizer(target: self, action: #selector(actionShowAuthorProfile))
        imageViewProfile.addGestureRecognizer(gestureShowProfile)
        
        let gestureShowProfile2 = UITapGestureRecognizer(target: self, action: #selector(actionShowAuthorProfile))
        labelFullName.addGestureRecognizer(gestureShowProfile2)
        
        let gestureReact = UITapGestureRecognizer(target: self, action: #selector(actionReact))
        imageViewReact.addGestureRecognizer(gestureReact)
        
        let gestureComment = UITapGestureRecognizer(target: self, action: #selector(actionComment))
        imageViewComment.addGestureRecognizer(gestureComment)
        
        let gestureShare = UITapGestureRecognizer(target: self, action: #selector(actionShare))
        imageViewShare.addGestureRecognizer(gestureShare)
    }
    
    func configure(with post: TextPost) {
        
        labelContent.text = post.content
        
        FirebaseManager.shared.fetchUserInfo(by: post.author) { user, userInfo in
            self.labelFullName.text = "\(user.name) \(user.surname)"
            self.labelCourseAndFaculty.text = "\(user.course), \(user.faculty)"
            
            self.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
        let referenceOfReact = FirebaseManager.dbPosts.child(post.id).child("reacts").child(post.author)
        
        referenceOfReact.observe(.value) { snapshot in
            self.changeReact(with: snapshot.exists())
        }
        
    }
    
    // MARK: - Actions
    
    @objc func actionShowAuthorProfile() {
        delegate.goToAuthorProfile(cell: self)
    }
    
    @objc func actionReact() {
        delegate.react(cell: self)
    }
    
    @objc func actionComment() {
        delegate.comment(cell: self)
    }
    
    @objc func actionShare() {
        delegate.share(cell: self)
    }
    
    // MARK: - Other Functions
    
    func changeReact(with reacted: Bool) {
        
        if reacted {
            imageViewReact.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

            UIView.animate(
                withDuration: 1.2,
                delay: 0.0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 0.2,
                options: .curveEaseOut,
                animations: {
                    self.imageViewReact.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.imageViewReact.image = UIImage(named: "heart.fill")
                    self.imageViewReact.tintColor = .systemPink
                },
                completion: nil)
        } else {
            imageViewReact.image = UIImage(named: "heart")
            imageViewReact.tintColor = .colorPrimary
        }
        
    }
    
}
