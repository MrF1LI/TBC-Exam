//
//  PollCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

protocol PollCellDelegate {
    func selectOption(cell: PollCell)
}

class PollCell: UITableViewCell {
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelCourseAndFaculty: UILabel!
    
    @IBOutlet weak var labelQuestion: UILabel!
    
    @IBOutlet weak var imageViewReact: UIImageView!
    @IBOutlet weak var imageViewComment: UIImageView!
    @IBOutlet weak var imageViewShare: UIImageView!
    
    @IBOutlet weak var tableViewOptions: UITableView!
    @IBOutlet weak var tableViewOptionsConstraint: NSLayoutConstraint!
    
    var arrayOfOptions = [Poll.Option]()
    
    var delegate: PollCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableViewOptions.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        configureDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: Functions
    
    func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 35
        contentView.layer.masksToBounds = true
        tableViewOptions.delegate = self
        tableViewOptions.dataSource = self
        tableViewOptions.register(UINib(nibName: "OptionCell", bundle: nil), forCellReuseIdentifier: "OptionCell")
        self.addObserver(tableViewOptions, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func configure(with post: Poll) {
        
        labelQuestion.text = post.question
        
        arrayOfOptions = post.options.map { $1 }
        
        FirebaseManager.shared.fetchUserInfo(by: post.author) { user, userInfo in
            self.labelFullName.text = "\(user.name) \(user.surname)"
            self.labelCourseAndFaculty.text = "\(user.course), \(user.faculty)"
            
            self.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
    }
    
}

extension PollCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentOption = arrayOfOptions[indexPath.row]
        cell.configureTableDesign()
        cell.configure(with: currentOption)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = tableView.cellForRow(at: indexPath) as? OptionCell
//        guard let cell = cell else { return }
//        let isSelected = cell.buttonOption.isSelected
//
//        if isSelected {
//            cell.buttonOption.isSelected = false
//        } else {
//            cell.buttonOption.isSelected = true
//        }
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewOptionsConstraint.constant = newSize.height
                }
            }
        }
        
    }
    
}
