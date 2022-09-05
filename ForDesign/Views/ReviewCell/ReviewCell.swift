//
//  ReviewCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 21.08.22.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var lecturerRating: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureDesign()
    }
    
    func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with review: Review) {
        
        labelDate.text = review.date
        labelContent.text = review.text
        
        guard let lecturerId = review.lecturer else { return }
        
        FirebaseManager.dbUsers.child(review.author).observeSingleEvent(of: .value) { snapshot in
            let user = snapshot.decode(class: User.self)
            guard let user = user else { return }
            self.labelFullName.text = "\(user.name) \(user.surname)"
            self.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user.default"),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
        FirebaseManager.dbLecturers.child(lecturerId).observe(.value) { snapshot in
            let lecturer = snapshot.decode(class: Lecturer.self)
            guard let lecturer = lecturer else { return }
                        
            self.lecturerRating.rating = Double(lecturer.rates?[review.author] ?? 0)
        }
        
    }
    
}
