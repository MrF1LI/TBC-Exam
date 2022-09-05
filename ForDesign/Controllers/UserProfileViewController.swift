//
//  UserProfileViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var tableViewUserInfo: UITableView!
    @IBOutlet weak var tableViewUserInfoConstraint: NSLayoutConstraint!
    
    var arrayOfUserInfo = [UserInfo]()
    
    var user: User!
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        loadUserInfo()
    }
    
    // MARK: Functions
    
    func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)
        tableViewUserInfo.configure(with: "UserInfoCell", for: self, cornerStyle: .item)
    }
    
    func loadUserInformation() {
        
        arrayOfUserInfo = [
            UserInfo(name: "18", image: .age),
            UserInfo(name: "IV Course", image: .course),
            UserInfo(name: "Information Technology", image: .faculty)
        ]
        
    }
    
    func loadUserInfo() {
        
        labelFullName.text = "\(user.name) \(user.surname)"
        labelEmail.text = "\(user.email)"
        
        imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                     placeholderImage: UIImage(named: "user"),
                                     options: .continueInBackground,
                                     completed: nil)
    }

}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfUserInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as? UserInfoCell
        guard let cell = cell else { return UITableViewCell() }
        
        let userInfo = arrayOfUserInfo[indexPath.row]
        cell.configure(with: userInfo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: For table view height
    
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
