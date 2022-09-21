//
//  MemesViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class MemesViewController: UIViewController, MemesDataSourceDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionViewMemes: UICollectionView!
    
    // MARK: - Private properties
    
    private var viewModel: MemesViewModel!
    private var dataSource: MemesDataSource!
    private var firebaseManager: FirebaseManager!
    
    // MARK: - Varlables
    
    var scale = 3
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureLayout()
        configureViewModel()
        dataSource.loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.setValue(dataSource.scale, forKey: "scale")
    }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        collectionViewMemes.register(UINib(nibName: "MemeCell", bundle: nil), forCellWithReuseIdentifier: "MemeCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionViewMemes.collectionViewLayout = layout
        
        // columns
        
        scale = UserDefaults.standard.value(forKey: "scale") as? Int ?? 3
    }
    
    private func configureViewModel() {
        firebaseManager = FirebaseManager()
        viewModel = MemesViewModel(with: firebaseManager)
        dataSource = MemesDataSource(collectionView: collectionViewMemes, viewModel: viewModel, delegate: self, scale: scale)
    }
    
    // MARK: - Functions
    
    func showMeme(selectedIndex: Int, arrayOfMemes: [MemeViewModel]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController
        guard let vc = vc else { return }
        
        vc.selectedIndex = selectedIndex
        vc.arrayOfMemes = arrayOfMemes
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func actionAddMeme(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddMemeViewController")
        guard let vc = vc else { return }
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        present(navigationController, animated: true)
    }

}
