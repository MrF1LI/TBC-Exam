//
//  LecturerCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit
import SDWebImage

class LecturerCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var imageViewRecomendation: UIImageView!
    
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
    
    func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)
    }
    
    func configure(with lecturer: Lecturer) {
        
        labelFullName.text = "\(lecturer.name) \(lecturer.surname)"
        labelSubject.text = lecturer.subject
        
        imageViewProfile.sd_setImage(with: URL(string: lecturer.profile),
                                           placeholderImage: UIImage(named: "user.default"),
                                           options: .continueInBackground,
                                           completed: nil)
        
        // Lecturer rating
        
        let rating = lecturer.getRating()
        labelRating.text = String(format: "%.1f", rating)
        
        imageViewRecomendation.isHidden = !lecturer.isRecomended()
        
    }
    
}
