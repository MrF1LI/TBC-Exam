//
//  ProfileViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
        
    @IBOutlet weak var tableViewUserInfo: UITableView!
    @IBOutlet weak var tableViewUserInfoConstraint: NSLayoutConstraint!
    
    var arrayOfUserInfo = [UserInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        loadUserInformation()
        listenToNotifications()
    }
    
    // MARK: - Functions
    
    private func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)
        tableViewUserInfo.configure(with: "UserInfoCell", for: self, cornerStyle: .item)
    }
    
    private func loadUserInformation() {
        
        FirebaseManager.shared.fetchUserInfo(by: FirebaseManager.currentUser!.uid) { [weak self] user, arrayOfUserInfo in

            self?.labelFullName.text = "\(user.name) \(user.surname)"
            self?.labelEmail.text = user.email
            
            self?.arrayOfUserInfo = arrayOfUserInfo
            self?.tableViewUserInfo.reloadData()
            
            self?.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
            
        }
                
    }
    
    private func listenToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(actionReloadInfo), name: Notification.Name("profileInfoUpdated"), object: nil)
    }
    
    // MARK: Actions
    
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
    
    // MARK: Navigation Functinos
    
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
