//
//  ChatsViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class ChatsViewController: UIViewController {
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationBar()
    }
    
    // MARK: - Private functions
    
    private func configureNavigationBar() {
        let buttonBack = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        
        let buttonIcon = UIImage(systemName: "arrow.backward")
        buttonBack.setImage(buttonIcon, for: .normal)
        buttonBack.layer.cornerRadius = 35/2
        buttonBack.tintColor = .colorPrimary
        buttonBack.backgroundColor = .colorItem
        
        buttonBack.addTarget(self, action: #selector(actionGoBack), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = leftBarButton
        
        navigationItem.title = "Chats"
        
        let font: UIFont = .systemFont(ofSize: 20)
        let color: UIColor = .colorPrimary
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: color,
            .font: font
        ]
    }
    
    // MARK: - Actions
    
    @objc func actionGoBack() {
        navigationController?.popViewController(animated: true)
    }
    
}
