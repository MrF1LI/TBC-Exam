//
//  UserProfileDataSource.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 10.09.22.
//

import UIKit

class UserProfileDataSource: NSObject {
    
    // MARK: - Private properties
    
    private var tableView: UITableView
    private var viewModel: UserProfileViewModel
    private var arrayOfUserInfo = [InfoViewModel]()
    
    // MARK: - Init
    
    init(tableView: UITableView, viewModel: UserProfileViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        configureDelegates()
    }
    
    // MARK: - Functions
    
    private func configureDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func loadData(completion: @escaping (UserViewModel) -> Void) {
        viewModel.getUserInfo { userInfo, user in
            self.arrayOfUserInfo = userInfo
            self.tableView.reloadData()
            completion(user)
        }
    }
    
}

// MARK: - Extension for tableview

extension UserProfileDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfUserInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as? UserInfoCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentInfo = arrayOfUserInfo[indexPath.row]
        cell.configure(with: currentInfo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
