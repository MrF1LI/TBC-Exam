//
//  RatesViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class RatesViewController: UIViewController, LecturersDataSourceDelegate {
    
    // MARK: - Outleats
    
    @IBOutlet weak var tableViewLecturers: UITableView!
    @IBOutlet weak var tableViewLecturersConstraint: NSLayoutConstraint!
    
    // MARK: - Private properties
        
    private var viewModel: LecturersViewModel!
    private var dataSource: LecturersDataSource!
    private var firebaseManager: FirebaseManager!
            
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureLayout()
        configureViewModel()
        dataSource.loadData()
        addListeners()
    }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        tableViewLecturers.register(UINib(nibName: "LecturerCell", bundle: nil), forCellReuseIdentifier: "LecturerCell")
        tableViewLecturers.setCornerStyle(.item)
    }
    
    private func configureViewModel() {
        firebaseManager = FirebaseManager()
        viewModel = LecturersViewModel(with: firebaseManager)
        dataSource = LecturersDataSource(tableView: tableViewLecturers, viewModel: viewModel, delegate: self)
    }
    
    private func addListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(actionReload), name: Notification.Name("rated"), object: nil)
    }
    
    // MARK: - Functions
    
    func showInformation(of lecturer: LecturerViewModel) {
        let lecturerVC = storyboard?.instantiateViewController(withIdentifier: "LecturerViewController") as? LecturerViewController
        guard let lecturerVC = lecturerVC else { return }
        
        let lect = Lecturer(id: lecturer.id, name: lecturer.name, surname: lecturer.surname
                            , email: lecturer.email, subject: lecturer.subject, profile: lecturer.profile, rates: lecturer.rates, recommended: lecturer.recommended)
        
        lecturerVC.lecturer = lect
        navigationController?.pushViewController(lecturerVC, animated: true)
    }
    
    // MARK: - Actions
    
    @objc func actionReload() {
        dataSource.loadData()
    }

}

// MARK: - Extension for table view height

extension RatesViewController {
    
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
