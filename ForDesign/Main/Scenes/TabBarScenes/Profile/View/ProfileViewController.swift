//
//  ProfileViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
        
    @IBOutlet weak var tableViewUserInfo: UITableView!
    @IBOutlet weak var tableViewUserInfoConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    private var viewModel: UserInfoViewModel!
    private var dataSource: UserInfoDataSource!
    private var firebaseManager: FirebaseManager!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureLayout()
        configureViewModel()
        loadUserInformation()
        loadUserInformation()
        listenToNotifications()
    }
    
    // MARK: - Private Functions
    
    private func configureLayout() {
        imageViewProfile.setCornerStyle(.capsule)
        tableViewUserInfo.setCornerStyle(.item)
        tableViewUserInfo.register(UINib(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: "UserInfoCell")
    }
    
    private func configureViewModel() {
        firebaseManager = FirebaseManager()
        viewModel = UserInfoViewModel(with: firebaseManager)
        dataSource = UserInfoDataSource(tableView: tableViewUserInfo, viewModel: viewModel)
    }
    
    private func loadUserInformation() {
        
        dataSource.loadData { [weak self] user in
            
            self?.labelFullName.text = "\(user.name) \(user.surname)"
            self?.labelEmail.text = user.email
                        
            self?.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
            
        }
        
    }
    
    private func listenToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(actionReloadInfo), name: Notification.Name("profileInfoUpdated"), object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func actionLogOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            goToLogInPage()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func actionEditProfile(_ sender: UIButton) {
        goToEditProfile()
    }
    
    @objc func actionReloadInfo() {
        loadUserInformation()
    }
    
    // MARK: - Navigation Functinos
    
    func goToLogInPage() {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        guard let loginVC = loginVC else { return }

        view.window?.rootViewController = loginVC
        navigationController?.popViewController(animated: true)
    }
    
    func goToEditProfile() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")
        guard let vc = vc else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - Extension For table view height

extension ProfileViewController {
    
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
