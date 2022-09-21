//
//  UserProfileViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var tableViewUserInfo: UITableView!
    @IBOutlet weak var tableViewUserInfoConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
        
    private var viewModel: UserProfileViewModel!
    private var dataSource: UserProfileDataSource!
    private var firebaseManager: FirebaseManager!

    var userId: String!
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureDesign()
        configureViewModel()
        loadUserInfo()
    }
    
    // MARK: - Private Functions
    
    private func configureNavigationBar() {
        let buttonBack = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        
        let buttonIcon = UIImage(systemName: "arrow.backward")
        buttonBack.setImage(buttonIcon, for: .normal)
        buttonBack.layer.cornerRadius = 35/2
        buttonBack.tintColor = .colorPrimary
        buttonBack.backgroundColor = .colorItem
        
        buttonBack.addTarget(self, action: #selector(actionGoBack), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)
        tableViewUserInfo.setCornerStyle(.item)
        tableViewUserInfo.register(UINib(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: "UserInfoCell")
    }
    
    private func configureViewModel() {
        firebaseManager = FirebaseManager()
        viewModel = UserProfileViewModel(with: firebaseManager)
        dataSource = UserProfileDataSource(tableView: tableViewUserInfo, viewModel: viewModel)
    }
    
    // TODO: - Load
    
    private func loadUserInfo() {
        tableViewUserInfo.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        dataSource.loadData { [weak self] user in
            self?.labelFullName.text = "\(user.name) \(user.surname)"
            self?.labelEmail.text = "\(user.email)"
            
            self?.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                         placeholderImage: UIImage(named: "user"),
                                         options: .continueInBackground,
                                         completed: nil)
        }
    }
    
    // MARK: - Actions
    
    @objc func actionGoBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extension for table view height

extension UserProfileViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewUserInfo.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewUserInfoConstraint.constant = newSize.height
                }
            }
        }

    }
    
}
