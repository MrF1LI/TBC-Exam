//
//  LecturersDataSource.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 05.09.22.
//

import UIKit

protocol LecturersDataSourceDelegate {
    func showInformation(of lecturer: LecturerViewModel)
}

class LecturersDataSource: NSObject {
    
    // MARK: - Private properties
    
    private var tableView: UITableView
    private var viewModel: LecturersViewModel
    private var arrayOfLecturers = [LecturerViewModel]()
    private var delegate: LecturersDataSourceDelegate!
    
    // MARK: - Init
    
    init(tableView: UITableView, viewModel: LecturersViewModel, delegate: LecturersDataSourceDelegate) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.delegate = delegate
        super.init()
        configureDelegates()
    }
    
    // MARK: - Functions
    
    private func configureDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func loadData() {
        viewModel.getLecturers { arrayOfLecturers in
            self.arrayOfLecturers = arrayOfLecturers
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Extension for TableView

extension LecturersDataSource: UITableViewDelegate, UITableViewDataSource {
    
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
        delegate.showInformation(of: currentLecturer)
    }
    
}
