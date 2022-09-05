//
//  CreatePostViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 30.08.22.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var textViewPost: UITextView!
    @IBOutlet weak var backgroundPostItems: UIView!
    @IBOutlet weak var backgroundPostItemsConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewPhotoVideo: UIStackView!
    @IBOutlet weak var stackViewPoll: UIStackView!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var collectionViewImagesHeight: NSLayoutConstraint!
    
    var postType: PostType = .text
    
    var imageData: [Data] = []
    var arrayOfImages = [UIImage]()
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        configureNavigationBar()
        configureGestures()
        listenToKeyboard()
        configureCollectionView()
    }
    
    private func configureDesign() {
        textViewPost.becomeFirstResponder()
        
        // Shadow
        
        backgroundPostItems.layer.shadowOffset = CGSize(width: 0,
                                          height: -10)
        backgroundPostItems.layer.shadowRadius = 10
        backgroundPostItems.layer.shadowOpacity = 0.1
        
        //
        
        collectionViewImagesHeight.constant = 0
    }
    
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

        
        let rightBarButton = UIBarButtonItem(title: "POST", style: .done, target: self, action: #selector(actionPost))
        rightBarButton.tintColor = .colorBTU
        
        navigationItem.rightBarButtonItem = rightBarButton
        
        //
        
        navigationItem.title = "Create Post"
        
        let font: UIFont = .systemFont(ofSize: 18)
        let color: UIColor = .colorPrimary
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: color,
            .font: font
        ]
                
    }
    
    private func configureGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionAddImage))
        stackViewPhotoVideo.addGestureRecognizer(gesture)
    }
    
    private func configureCollectionView() {
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        collectionViewImages.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    // MARK: - Actions
    
    @objc func actionGoBack() {
        dismiss(animated: true)
    }
    
    @objc func actionPost() {
        
        guard let text = textViewPost.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        if !imageData.isEmpty {
            postType = .images
        }
        
        showSpinner()
        
        switch postType {
        case .text:
            FirebaseManager.shared.post(text: text) {
                self.dismiss(animated: true)
            }
        case .images:
            FirebaseManager.shared.post(text: text, arrayOfImageData: imageData) {
                self.dismiss(animated: true)
            }
        case .poll:
            break
        }

    }
    
    @objc func actionAddImage() {
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

// MARK: For keyboard

extension CreatePostViewController {
    
    func listenToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        
        if #available(iOS 11.0, *){
            self.backgroundPostItemsConstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom
        }
        else {
            self.backgroundPostItemsConstraint.constant = view.safeAreaInsets.bottom
        }
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        self.backgroundPostItemsConstraint.constant =  0
        
        UIView.animate(withDuration: 0.5){ [weak self] in
            self?.view.layoutIfNeeded()
        }
        
    }
    
}

// MARK: Extension for image picker

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
    
        guard let imageData = image.pngData() else {
            return
        }
        
        self.imageData.append(imageData)
        arrayOfImages.append(image)
        collectionViewImagesHeight.constant = 100
        collectionViewImages.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension CreatePostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        let currentImage = arrayOfImages[indexPath.row]
        cell.configure(with: currentImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        deleteAlert(indexPath: indexPath)
    }
    
    func deleteAlert(indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Remove image?", message: nil, preferredStyle: .alert)
        
        let actionRemove = UIAlertAction(title: "Remove", style: .default) { [weak self] _ in
            self?.arrayOfImages.remove(at: indexPath.row)
            self?.imageData.remove(at: indexPath.row)
            self?.collectionViewImages.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(actionRemove)
        alert.addAction(actionCancel)

        present(alert, animated: true)
    }
}
