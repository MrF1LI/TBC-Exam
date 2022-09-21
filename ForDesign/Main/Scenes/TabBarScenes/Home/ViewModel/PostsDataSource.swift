//
//  PostsDataSource.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 07.09.22.
//

import UIKit

protocol PostsDataSourceDelegate {
    func showProfile(of user: String)
    func react(post: PostViewModel)
    func showComments(of post: PostViewModel)
}

class PostsDataSource: NSObject {
    
    // MARK: - Private properties
    
    private var tableView: UITableView
    private var viewModel: PostsViewModel!
    private var arrayOfPosts = [PostViewModel]()
    private var delegate: PostsDataSourceDelegate
    
    // MARK: - Init
    
    init(tableView: UITableView, viewModel: PostsViewModel, delegate: PostsDataSourceDelegate) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.delegate = delegate
        super.init()
        configureDelegates()
        addListener()
    }
    
    // MARK: - Functions
    
    private func configureDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(actionReload), name: Notification.Name("newPost"), object: nil)
    }
    
    func loadData() {
        viewModel.getPosts { [weak self] arrayOfPosts in
            self?.arrayOfPosts = arrayOfPosts
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func actionReload() {
        loadData()
    }
    
}

// MARK: - Extension for CollectionView

extension PostsDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPost = arrayOfPosts[indexPath.row]
        
        if currentPost is TextPostViewModel {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath) as? TextPostCell
            guard let cell = cell else { return UITableViewCell() }
            
            cell.configureTableDesign()
            cell.delegate = self
            cell.configure(with: currentPost as! TextPostViewModel)
            
            return cell
            
        } else if currentPost is ImagePostViewModel {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePostCell", for: indexPath) as? ImagePostCell
            guard let cell = cell else { return UITableViewCell() }
            
            cell.configureTableDesign()
            cell.delegate = self
            cell.configure(with: currentPost as! ImagePostViewModel)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
}

// MARK: - Extension for post actions

protocol PostCellDelegate {
    func react(cell: UITableViewCell)
    func comment(cell: UITableViewCell)
    func share(cell: UITableViewCell)
    func goToAuthorProfile(cell: UITableViewCell)
}

extension PostsDataSource: PostCellDelegate {
    
    func react(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let post = arrayOfPosts[indexPath.row]
            delegate.react(post: post)
        }
    }
    
    func comment(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let post = arrayOfPosts[indexPath.row]
            delegate.showComments(of: post)
        }
    }
    
    func share(cell: UITableViewCell) {
        print(#function)
    }
    
    func goToAuthorProfile(cell: UITableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            let post = arrayOfPosts[indexPath.row]
            delegate.showProfile(of: post.author)
        }

    }
        
}
