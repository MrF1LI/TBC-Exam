//
//  TabBarViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationBar()
    }
    
    // MARK: - Private functions
    
    private func configureNavigationBar() {
        let label = UILabel()
        label.text = "Students"
        label.textColor = .colorBTU
        label.font = UIFont(name: "Chalkboard SE", size: 24)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        navigationItem.scrollEdgeAppearance?.backgroundColor = .colorItem
    }
    
    // MARK: Actions

    @IBAction func actionOpenChats(_ sender: UIBarButtonItem) {
        let chatsVC = UIHostingController(rootView: ChatListView())
        navigationController?.pushViewController(chatsVC, animated: true)
    }

}
