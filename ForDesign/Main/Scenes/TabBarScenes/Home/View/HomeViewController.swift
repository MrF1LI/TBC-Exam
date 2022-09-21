//
//  HomeViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var viewAddPostBackground: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!

    @IBOutlet weak var tableViewPosts: UITableView!
    @IBOutlet weak var tableViewPostsConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    private var viewModel: PostsViewModel!
    private var dataSource: PostsDataSource!
    private var firebaseManager: FirebaseManager!
    
//    var arrayOfPosts = [Post]()
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureViewModel()
        
        dataSource.loadData()
            
        configureDesign()
        loadUserProfile()
    }
    
    // MARK: - Functions
    
    private func configureViewModel() {
        tableViewPosts.register(UINib(nibName: "TextPostCell", bundle: nil), forCellReuseIdentifier: "TextPostCell")
        tableViewPosts.register(UINib(nibName: "ImagePostCell", bundle: nil), forCellReuseIdentifier: "ImagePostCell")
        
        firebaseManager = FirebaseManager()
        viewModel = PostsViewModel(with: firebaseManager)
        dataSource = PostsDataSource(tableView: tableViewPosts, viewModel: viewModel, delegate: self)
    }
    
    func configureDesign() {
        viewAddPostBackground.setCornerStyle(.item)
        imageViewProfile.setCornerStyle(.capsule)
    }
    
    func loadUserProfile() {
                
        FirebaseManager.shared.fetchUserInfo(by: FirebaseManager.currentUser!.uid) { [weak self] user, _ in
            self?.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user")?.withTintColor(.colorBTU),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func actionAddPost(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController
        guard let vc = vc else { return }
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
    
}

// MARK: - Extension for post actions

extension HomeViewController: PostsDataSourceDelegate {
    
    func react(post: PostViewModel) {
        firebaseManager.react(post: post) {
            print("reacted")
        }
    }
    
    func showComments(of post: PostViewModel) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController
        guard let vc = vc else { return }
        
        vc.post = post
        present(vc, animated: true)
    }
    
    func showProfile(of user: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
        guard let vc = vc else { return }


        vc.userId = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Extension for table view height

extension HomeViewController {
    override func viewDidAppear(_ animated: Bool) {
        
        tableViewPosts.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewPostsConstraint.constant = newSize.height
                }
            }
        }

    }
    
}
