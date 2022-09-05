//
//  ConfigUserInfo.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import Foundation
import UIKit

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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
