//
//  ConfigLecturers.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import Foundation
import UIKit

extension RatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfLecturers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturerCell", for: indexPath) as? LecturerCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentLecturer = arrayOfLecturers[indexPath.row]
        cell.configure(with: currentLecturer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentLecturer = arrayOfLecturers[indexPath.row]
        showInformation(of: currentLecturer)
    }
    
    // MARK: - Functions
    
    func showInformation(of lecturer: Lecturer) {
        let lecturerVC = storyboard?.instantiateViewController(withIdentifier: "LecturerViewController") as? LecturerViewController
        guard let lecturerVC = lecturerVC else { return }
        
        lecturerVC.lecturer = lecturer
        navigationController?.pushViewController(lecturerVC, animated: true)
    }
    
    // For table view height
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewLecturers.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewLecturersConstraint.constant = newSize.height
                }
            }
        }
        
    }
    
}
