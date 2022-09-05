//
//  MemesViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class MemesViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var collectionViewMemes: UICollectionView!
    
    var arrayOfMemes = [Meme]()
    var scale = 3
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollectionView()
        loadMemes()
    }
    
    // MARK: - Initial Functions

    func configureCollectionView() {
        collectionViewMemes.configure(with: "MemeCell", for: self, cornerStyle: nil)

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionViewMemes.collectionViewLayout = layout
        
        // columns
        
        scale = UserDefaults.standard.value(forKey: "scale") as? Int ?? 3
    }
    
    func loadMemes() {
        
        FirebaseManager.shared.fetchMemes { [weak self] arrayOfMemes in
            self?.arrayOfMemes = arrayOfMemes
            self?.collectionViewMemes.reloadData()
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func actionAddMeme(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddMemeViewController")
        guard let vc = vc else { return }
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        present(navigationController, animated: true)
    }

}
