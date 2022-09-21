//
//  UserInfoDataSource.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 05.09.22.
//

import UIKit

class UserInfoDataSource: NSObject {
    
    // MARK: - Private properties
    
    private var tableView: UITableView
    private var viewModel: UserInfoViewModel
    private var arrayOfUserInfo = [InfoViewModel]()
    
    // MARK: - Init
    
    init(tableView: UITableView, viewModel: UserInfoViewModel) {
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

extension UserInfoDataSource: UITableViewDelegate, UITableViewDataSource {
    
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
