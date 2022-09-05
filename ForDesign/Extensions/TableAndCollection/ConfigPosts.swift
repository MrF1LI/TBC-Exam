//
//  ConfigPosts.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPost = arrayOfPosts[indexPath.row]
        
        if currentPost is TextPost {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath) as? TextPostCell
            guard let cell = cell else { return UITableViewCell() }
            
            cell.configureTableDesign()
            cell.delegate = self
            cell.configure(with: currentPost as! TextPost)
            
            return cell
            
        } else if currentPost is ImagePost {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePostCell", for: indexPath) as? ImagePostCell
            guard let cell = cell else { return UITableViewCell() }
            
            cell.configureTableDesign()
            cell.delegate = self
            cell.configure(with: currentPost as! ImagePost)
            
            return cell
            
        } else if currentPost is Poll {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath) as? PollCell
            guard let cell = cell else { return UITableViewCell() }
            
            cell.configureTableDesign()
//            cell.delegate = self
            cell.configure(with: currentPost as! Poll)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // MARK: For table view height
    
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
