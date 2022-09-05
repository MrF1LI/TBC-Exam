//
//  HomeViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var viewAddPostBackground: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!

    @IBOutlet weak var tableViewPosts: UITableView!
    @IBOutlet weak var tableViewPostsConstraint: NSLayoutConstraint!
    
    var arrayOfPosts = [Post]()
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        loadUserProfile()
        loadPosts()
    }
    
    // MARK: Functions
    
    func configureDesign() {
        viewAddPostBackground.setCornerStyle(.item)
        imageViewProfile.setCornerStyle(.capsule)
        tableViewPosts.configure(with: "TextPostCell", for: self, cornerStyle: nil)
        tableViewPosts.configure(with: "ImagePostCell", for: self, cornerStyle: nil)
        tableViewPosts.configure(with: "PollCell", for: self, cornerStyle: nil)
    }
    
    func loadPosts() {
        
        arrayOfPosts.removeAll()
        
        FirebaseManager.dbPosts.observe(.childAdded) { [weak self] snapshot in
            let postType = snapshot.decode(class: PType.self)
            guard let postType = postType else { return }
            
            switch postType.type {
            case .text:
                let currentPost = snapshot.decode(class: TextPost.self)
                guard let currentPost = currentPost else { return }
                self?.arrayOfPosts.append(currentPost)
            case .images:
                let currentPost = snapshot.decode(class: ImagePost.self)
                guard let currentPost = currentPost else { return }
                self?.arrayOfPosts.append(currentPost)
            case .poll:
                let currentPost = snapshot.decode(class: Poll.self)
                guard let currentPost = currentPost else { return }
                self?.arrayOfPosts.append(currentPost)
            }
            
            self?.tableViewPosts.reloadData()
            
        }
        
    }
    
    func loadUserProfile() {
                
        FirebaseManager.shared.fetchUserInfo(by: FirebaseManager.currentUser!.uid) { [weak self] user, userInfo in
            self?.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user")?.withTintColor(.colorBTU),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func actionAddPost(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController
        guard let vc = vc else { return }
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }

}
