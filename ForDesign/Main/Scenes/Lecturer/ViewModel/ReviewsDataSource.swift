//
//  ReviewsDataSource.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 06.09.22.
//

import UIKit

class ReviewsDataSource: NSObject {
    
    // MARK: - Private properties
    
    private var tableView: UITableView
    private var viewModel: ReviewsViewModel!
    private var arrayOfReviews = [ReviewViewModel]()
    private var lecturer: Lecturer!
    
    // MARK: - Init
    
    init(tableView: UITableView, viewModel: ReviewsViewModel, lecturer: Lecturer) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.lecturer = lecturer
        super.init()
        configureDelegates()
    }
    
    // MARK: - Functions
    
    private func configureDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func loadData(completion: @escaping (Bool) -> Void) {
        viewModel.getReviews(of: lecturer) { arrayOfReviews in
            self.arrayOfReviews =  arrayOfReviews
            self.tableView.reloadData()
            completion(arrayOfReviews.count == 0)
        }
    }
    
}

// MARK: - Extension for table view

extension ReviewsDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
        guard let cell = cell else { return UITableViewCell() }
        
        var currentReview = arrayOfReviews[indexPath.row]
        currentReview.lecturer = lecturer.id
        cell.configure(with: currentReview)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
