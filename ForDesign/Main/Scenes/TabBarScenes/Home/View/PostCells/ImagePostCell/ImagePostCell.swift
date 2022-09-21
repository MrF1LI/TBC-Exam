//
//  ImagePostCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class ImagePostCell: UITableViewCell {
    
    // MARK: - Variables
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelCourseAndFaculty: UILabel!
    
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var imageViewReact: UIImageView!
    @IBOutlet weak var imageViewComment: UIImageView!
    @IBOutlet weak var imageViewShare: UIImageView!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Variables
    
    var arrayOfImages = [String]()
    
    var delegate: PostCellDelegate!
    let firebaseManager = FirebaseManager()
    
    var viewModel: ImagePostViewModel?
    
    // MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureLayout()
        configurePageControl()
        configureGestures()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: - Functions
    
    private func configureLayout() {
        collectionViewImages.configure(with: "PostImageCell", for: self, cornerStyle: nil)
        imageViewProfile.setCornerStyle(.capsule)
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 35
        contentView.layer.masksToBounds = true

    }
    
    private func configurePageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = arrayOfImages.count
        pageControl.isUserInteractionEnabled = false
    }
    
    private func configureGestures() {
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
    
    func configure(with viewModel: ImagePostViewModel) {
        
        arrayOfImages = viewModel.images.values.map { $0 }
        pageControl.numberOfPages = arrayOfImages.count
        
        labelContent.text = viewModel.content
        
        FirebaseManager.shared.fetchUserInfo(by: viewModel.author) { user, userInfo in
            self.labelFullName.text = "\(user.name) \(user.surname)"
            self.labelCourseAndFaculty.text = "\(user.course), \(user.faculty)"
            
            self.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
        self.viewModel = viewModel
        let referenceOfReact = firebaseManager.dbPosts.child(viewModel.id).child("reacts").child(viewModel.author)

        referenceOfReact.observe(.value) { snapshot in
            
            if snapshot.exists() {
                self.imageViewReact.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.imageViewReact.image = UIImage(named: "heart.fill")
                self.imageViewReact.tintColor = .systemPink
            } else {
                self.imageViewReact.image = UIImage(named: "heart")
                self.imageViewReact.tintColor = .colorPrimary
            }
            
        }
    
    }
    
    // MARK: - Actions
    
    @objc func actionShowAuthorProfile() {
        delegate.goToAuthorProfile(cell: self)
    }
    
    @objc func actionReact() {
        let referenceOfReact = firebaseManager.dbPosts.child(viewModel?.id ?? "").child("reacts").child(viewModel?.author ?? "")
        
        referenceOfReact.observe(.value) { snapshot in
            self.changeReact(with: snapshot.exists())
        }
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
//            imageViewReact.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            self.imageViewReact.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.imageViewReact.image = UIImage(named: "heart.fill")
            self.imageViewReact.tintColor = .systemPink

//            UIView.animate(
//                withDuration: 1.2,
//                delay: 0.0,
//                usingSpringWithDamping: 0.2,
//                initialSpringVelocity: 0.2,
//                options: .curveEaseOut,
//                animations: {
//                    self.imageViewReact.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    self.imageViewReact.image = UIImage(named: "heart.fill")
//                    self.imageViewReact.tintColor = .systemPink
//                },
//                completion: nil)
            
        } else {
            imageViewReact.image = UIImage(named: "heart")
            imageViewReact.tintColor = .colorPrimary
        }
        
    }
    
}

// MARK: - Extension for collection view

extension ImagePostCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as? PostImageCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        let currentImage = arrayOfImages[indexPath.row]
        cell.configure(with: currentImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
}
