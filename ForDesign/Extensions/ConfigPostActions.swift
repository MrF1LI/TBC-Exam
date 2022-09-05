//
//  ConfigPostActions.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 29.08.22.
//

import UIKit

protocol PostCellDelegate {
    func react(cell: UITableViewCell)
    func comment(cell: UITableViewCell)
    func share(cell: UITableViewCell)
    func goToAuthorProfile(cell: UITableViewCell)
}

extension HomeViewController: PostCellDelegate {
    
    func react(cell: UITableViewCell) {
        if let indexPath = tableViewPosts.indexPath(for: cell) {
            let post = arrayOfPosts[indexPath.row]
            react(post: post)
        }
    }
    
    func comment(cell: UITableViewCell) {
        if let indexPath = tableViewPosts.indexPath(for: cell) {
            let post = arrayOfPosts[indexPath.row]
            showComments(of: post)
        }
    }
    
    func share(cell: UITableViewCell) {
        print(#function)
    }
    
    func goToAuthorProfile(cell: UITableViewCell) {
        
        if let indexPath = tableViewPosts.indexPath(for: cell) {
            let post = arrayOfPosts[indexPath.row]
            showProfile(of: post.author)
        }

    }
    
    // MARK: - Navigation Functions
    
    func showProfile(of user: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
        guard let vc = vc else { return }
        
        
        FirebaseManager.shared.fetchUserInfo(by: user) { [weak self] user, userInfo in
            vc.user = user
            vc.arrayOfUserInfo = userInfo
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func showComments(of post: Post) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController
        guard let vc = vc else { return }
        
        vc.post = post
        present(vc, animated: true)
    }
    
    func react(post: Post) {
        
        FirebaseManager.shared.react(post: post) {
            print("reacted")
        }
        
    }

}
