//
//  AddMemeViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 31.08.22.
//

import UIKit

class AddMemeViewController: UIViewController {
    
    @IBOutlet weak var stackViewUploadMeme: UIStackView!
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    var memeData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureGestures()
    }
    
    private func configureNavigationBar() {
        title = "Add Meme"
        
        let buttonCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(actionCancel))
        
        navigationItem.leftBarButtonItem = buttonCancel
        
        let buttonAdd = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(actionAddMeme))
        buttonAdd.tintColor = .colorBTU
        
        navigationItem.rightBarButtonItem = buttonAdd
    }
    
    private func configureGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionUploadMeme))
        stackViewUploadMeme.addGestureRecognizer(gesture)
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(actionUploadMeme))
        imageViewMeme.addGestureRecognizer(imageGesture)
    }
    
    // MARK: - Actions
    
    @objc func actionCancel() {
        dismiss(animated: true)
    }
    
    @objc func actionAddMeme() {
        guard let memeData = memeData else {
            return
        }

        showSpinner()
        
        FirebaseManager.shared.uploadMeme(data: memeData) { [weak self] in
            self?.dismiss(animated: true)
        }
        
    }
    
    @objc func actionUploadMeme() {
        showImagePicker()
    }
    
    // MARK: Functions

    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

}

extension AddMemeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        imageViewMeme.image = image
        imageViewMeme.isHidden = false
        stackViewUploadMeme.isHidden = true
        memeData = imageData
        
    }
    
}
