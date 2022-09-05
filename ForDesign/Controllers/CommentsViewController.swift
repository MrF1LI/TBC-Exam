//
//  CommentsViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 29.08.22.
//

import UIKit

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableViewComments: UITableView!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var addCommentBackground: UIView!
    @IBOutlet weak var addCommentBackgroundConstraint: NSLayoutConstraint!
    
    var arrayOfComments = [Comment]()
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        loadComments()
        listenToKeyboard()
    }
    
    func configureDesign() {
        textFieldComment.setCapsuledStyle()
        textFieldComment.setHorizontalPadding()
        
        addCommentBackground.layer.shadowOffset = CGSize(width: 0,
                                          height: -10)
        addCommentBackground.layer.shadowRadius = 10
        addCommentBackground.layer.shadowOpacity = 0.1
        
        
        tableViewComments.delegate = self
        tableViewComments.dataSource = self
        tableViewComments.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
    }
    
    func loadComments() {
        let referenceOfComments = FirebaseManager.dbPosts.child(post.id).child("comments")
        referenceOfComments.observe(.childAdded) { [weak self] snapshot in
            let currentComment = snapshot.decode(class: Comment.self)
            guard let currentComment = currentComment else { return }
            
            self?.arrayOfComments.append(currentComment)
            self?.tableViewComments.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionAddComment(_ sender: UIButton) {
        guard let comment = textFieldComment.text,
        !comment.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        FirebaseManager.shared.comment(post: post, with: comment) { [weak self] in
            self?.textFieldComment.text = ""
        }
        
        
    }
    
    // MARK: - Change Keyboard Constraints
    
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

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell
        guard let cell = cell else { return UITableViewCell() }
        
        cell.configureTableDesign()
        let currentComment = arrayOfComments[indexPath.row]
        cell.configure(with: currentComment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
