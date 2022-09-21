//
//  ReviewCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 21.08.22.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    // MARK: - Variables
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var lecturerRating: CosmosView!
    
    let firebaseManager = FirebaseManager()
    
    // MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Functions
    
    private func configureLayout() {
        imageViewProfile.setCornerStyle(.capsule)
    }
    
    func configure(with viewModel: ReviewViewModel) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        labelDate.text = dateFormatter.string(from: viewModel.date)
        labelContent.text = viewModel.text
        
        // TODO: - Refactor MVVM
                
        firebaseManager.dbUsers.child(viewModel.author).observeSingleEvent(of: .value) { snapshot in
            let user = snapshot.decode(class: User.self)
            guard let user = user else { return }
            self.labelFullName.text = "\(user.name) \(user.surname)"
            self.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user.default"),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
        firebaseManager.dbLecturers.child(viewModel.lecturer).observe(.value) { snapshot in
            let lecturer = snapshot.decode(class: Lecturer.self)
            guard let lecturer = lecturer else { return }
                        
            self.lecturerRating.rating = Double(lecturer.rates?[viewModel.author] ?? 0)
        }
        
    }
    
}
