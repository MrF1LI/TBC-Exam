//
//  CommentsViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 29.08.22.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Outleats
    
    @IBOutlet weak var tableViewComments: UITableView!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var addCommentBackground: UIView!
    @IBOutlet weak var addCommentBackgroundConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    private var viewModel: CommentsViewModel!
    private var dataSource: CommentsDataSource!
    private var firebaseManager: FirebaseManager!
    
    var post: PostViewModel!
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        configureViewModel()
        dataSource.loadData(post: post)
        listenToKeyboard()
    }
    
    // MARK: - Private Functions
    
    private func configureDesign() {
        textFieldComment.setCapsuledStyle()
        textFieldComment.setHorizontalPadding()
        
        addCommentBackground.layer.shadowOffset = CGSize(width: 0,
                                          height: -10)
        addCommentBackground.layer.shadowRadius = 10
        addCommentBackground.layer.shadowOpacity = 0.1
        
        tableViewComments.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
    }
    
    private func configureViewModel() {
        firebaseManager = FirebaseManager()
        viewModel = CommentsViewModel(with: firebaseManager)
        dataSource = CommentsDataSource(tableView: tableViewComments, viewModel: viewModel)
    }
    
    // MARK: - Actions
    
    @IBAction func actionAddComment(_ sender: UIButton) {
        guard let comment = textFieldComment.text,
        !comment.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        viewModel.comment(post: post, with: comment) { [weak self] in
            self?.textFieldComment.text = ""
        }
    }
    
}

// MARK: - Extension for keyboard

extension CommentsViewController {
    
    func listenToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        
        if #available(iOS 11.0, *){
            self.addCommentBackgroundConstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom
        }
        else {
            self.addCommentBackgroundConstraint.constant = view.safeAreaInsets.bottom
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        self.addCommentBackgroundConstraint.constant =  0 // or change according to your logic
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
    }
    
}
