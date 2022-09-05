//
//  ConfigReviews.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 21.08.22.
//

import Foundation
import UIKit

extension LecturerViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    // MARK: For table view height
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewReviews.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewReviewsHeight.constant = newSize.height
                }
            }
        }
        
    }
    
}
