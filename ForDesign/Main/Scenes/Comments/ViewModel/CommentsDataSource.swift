//
//  CommentsDataSource.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 06.09.22.
//

import UIKit

class CommentsDataSource: NSObject {
    
    // MARK: - Private properties
    
    private var tableView: UITableView
    private var viewModel: CommentsViewModel
    private var arrayOfComments = [CommentViewModel]()
    
    // MARK: - Init
    
    init(tableView: UITableView, viewModel: CommentsViewModel) {
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
    
    func loadData(post: PostViewModel) {
        viewModel.getComments(of: post) { arrayOfComments in
            self.arrayOfComments = arrayOfComments
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Extension for TableView

extension CommentsDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentComment = arrayOfComments[indexPath.row]
        cell.configureTableDesign()
        cell.configure(with: currentComment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
