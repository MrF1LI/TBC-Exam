//
//  TabBarViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        let label = UILabel()
        label.text = "Students"
        label.textColor = .colorBTU
        label.font = UIFont(name: "Chalkboard SE", size: 24)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        navigationItem.scrollEdgeAppearance?.backgroundColor = .colorItem
    }
    
    // MARK: Actions

    @IBAction func actionOpenChats(_ sender: UIBarButtonItem) {
        let chatsVC = storyboard?.instantiateViewController(withIdentifier: "ChatsViewController")
        guard let chatsVC = chatsVC else { return }
        
        navigationController?.pushViewController(chatsVC, animated: true)
    }

}
