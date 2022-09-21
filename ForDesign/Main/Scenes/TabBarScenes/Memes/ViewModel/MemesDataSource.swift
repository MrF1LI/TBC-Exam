//
//  MemesDataSource.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 05.09.22.
//

import UIKit

protocol MemesDataSourceDelegate {
    func showMeme(selectedIndex: Int, arrayOfMemes: [MemeViewModel])
}

class MemesDataSource: NSObject {
    
    // MARK: - Private properties
    
    private var collectionView: UICollectionView
    private var viewModel: MemesViewModel!
    private var arrayOfMemes = [MemeViewModel]()
    private var delegate: MemesDataSourceDelegate!
    
    var scale: Int = 3
    
    // MARK: - Initializer
        
    init(collectionView: UICollectionView, viewModel: MemesViewModel, delegate: MemesDataSourceDelegate, scale: Int) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        self.delegate = delegate
        self.scale = scale
        super.init()
        configureDelegates()
        configureGestures()
    }
    
    // MARK: - Functions
    
    private func configureDelegates() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func configureGestures() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(actionCollectionView))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func actionCollectionView(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == .ended {
            if gesture.scale > 1 {
                if scale > 1 {
                    scale -= 1
                }
            } else {
                if scale < 5 {
                    scale += 1
                }
            }
            gesture.scale = 1
            collectionView.reloadData()
        }
        
    }
    
    func loadData() {
        viewModel.getMemes { arrayOfMemes in
            self.arrayOfMemes = arrayOfMemes
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - Extension for CollectionView

extension MemesDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfMemes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as? MemeCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        let currentMeme = arrayOfMemes[indexPath.row]
        cell.configure(with: currentMeme)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = collectionView.frame.width / CGFloat(scale) - 1
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.showMeme(selectedIndex: indexPath.row, arrayOfMemes: arrayOfMemes)
    }
    
}
