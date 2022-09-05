//
//  ConfigMemes.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 25.08.22.
//

import UIKit

extension MemesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let size: CGFloat = collectionViewMemes.frame.width / CGFloat(scale) - 1
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController
        guard let vc = vc else { return }
        
        vc.selectedIndex = indexPath.row
        vc.arrayOfMemes = arrayOfMemes
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
