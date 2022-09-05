//
//  RatesViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class RatesViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var tableViewLecturers: UITableView!
    @IBOutlet weak var tableViewLecturersConstraint: NSLayoutConstraint!
    
    var arrayOfLecturers = [Lecturer]()
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        loadLecturers()
    }
    
    // MARK: Functions
    
    func configureDesign() {
        tableViewLecturers.configure(with: "LecturerCell", for: self, cornerStyle: .item)
    }
    
    func loadLecturers() {
        
        FirebaseManager.shared.fetchLecturers { [weak self] arrayOfLecturers in
            self?.arrayOfLecturers = arrayOfLecturers
            self?.tableViewLecturers.reloadData()
        }
        
        FirebaseManager.dbLecturers.observe(.childChanged) { [weak self] snapshot in
            
            let lecturer = snapshot.decode(class: Lecturer.self)
            guard let lecturer = lecturer else { return }
            
            let row = self?.arrayOfLecturers.firstIndex { $0.id == lecturer.id }
            guard let row = row else { return }
            
            self?.arrayOfLecturers.remove(at: row)
            self?.arrayOfLecturers.insert(lecturer, at: row)
            
            let indexPath = IndexPath(row: row, section: 0)
            self?.tableViewLecturers.reloadRows(at: [indexPath], with: .none)

        }

    }
    

}
