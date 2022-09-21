//
//  GalleryViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 25.08.22.
//

import UIKit

class GalleryViewController: UIViewController {
    
    // MARK: - Views
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.contentMode = .scaleAspectFit
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .black
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 6
        
        return scrollView
    }()
    
    lazy var imageViewMeme: UIImageView = {
        let imageViewMeme = UIImageView()
        
        imageViewMeme.contentMode = .scaleAspectFit
        imageViewMeme.clipsToBounds = true
        imageViewMeme.isUserInteractionEnabled = true
         
        return imageViewMeme
    }()
    
    lazy var buttonClose: UIButton = {
        let buttonClose = UIButton()
        
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        buttonClose.setImage(image, for: .normal)
        buttonClose.tintColor = .white
        buttonClose.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
        
        return buttonClose
    }()
    
    lazy var labelCount: UILabel = {
        let labelCount = UILabel()
        labelCount.textColor = .white
        labelCount.textAlignment = .center
        return labelCount
    }()
    
    // MARK: - Variables
    
    var selectedIndex: Int!
    var arrayOfMemes: [MemeViewModel]!
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        configureConstraints()
        loadImage()
        configureGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Functions
    
    private func configureDesign() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(imageViewMeme)
        view.addSubview(buttonClose)
        view.addSubview(labelCount)
    }
    
    private func configureConstraints() {
        scrollView.frame = view.bounds
        imageViewMeme.frame = scrollView.bounds
        
        labelCount.frame = CGRect(x: 20,
                                 y: view.frame.height - 50,
                                 width: view.frame.width - 40,
                                 height: 21)
        
        buttonClose.frame = CGRect(x: 20,
                                   y: (self.navigationController?.navigationBar.frame.size.height)!,
                                   width: 25,
                                   height: 25)
    }
    
    private func loadImage() {
        let url = arrayOfMemes[selectedIndex].url
        
        imageViewMeme.sd_setImage(with: URL(string: url),
                                  placeholderImage: UIImage(named: "picture"),
                                  options: .continueInBackground,
                                  completed: nil)
        
        labelCount.text = "\(selectedIndex + 1) / \(arrayOfMemes.count)"
    }
    
    private func configureGestures() {
        let gestureSingleTap = UITapGestureRecognizer(target: self, action: #selector(actionSingleTap))
        gestureSingleTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(gestureSingleTap)
        
        let gestureDoubleTap = UITapGestureRecognizer(target: self, action: #selector(actionDoubleTap))
        gestureDoubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(gestureDoubleTap)
        
        gestureSingleTap.require(toFail: gestureDoubleTap)
        
        let gestureRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        gestureRightSwipe.direction = .right
        scrollView.addGestureRecognizer(gestureRightSwipe)
        
        let gestureLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        gestureLeftSwipe.direction = .left
        scrollView.addGestureRecognizer(gestureLeftSwipe)
    }
    
    // MARK: - Actions
    
    @objc func actionClose() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func actionSingleTap(gesture: UITapGestureRecognizer) {
        let hidden = buttonClose.isHidden
        buttonClose.isHidden = !hidden
        labelCount.isHidden = !hidden
    }
    
    @objc func actionDoubleTap(gesture: UITapGestureRecognizer) {
        
        if scrollView.zoomScale == 1 {
            let zoom = zoomRectForScale(scale: scrollView.maximumZoomScale, center: gesture.location(in: gesture.view))
            scrollView.zoom(to: zoom, animated: true)
            buttonClose.isHidden = true
            labelCount.isHidden = true
        } else {
            scrollView.setZoomScale(1, animated: true)
            buttonClose.isHidden = false
            labelCount.isHidden = false
        }
        
    }
    
    @objc func actionSwipe(gesture: UISwipeGestureRecognizer) {
        let direction = gesture.direction
        
        switch direction {
        case .right:
            self.selectedIndex -= 1
        case .left:
            self.selectedIndex += 1
        default:
            break
        }
        
        self.selectedIndex = (self.selectedIndex < 0) ? (self.arrayOfMemes.count - 1) : self.selectedIndex % self.arrayOfMemes.count
        loadImage()
    }
    
    // MARK: - Functions
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageViewMeme.frame.size.height / scale
        zoomRect.size.width = imageViewMeme.frame.size.width / scale
        
        let newCenter = imageViewMeme.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.x - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }

}

// MARK: - Extension for scrollview

extension GalleryViewController: UIScrollViewDelegate {
 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewMeme
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if scrollView.zoomScale > 1 {
            
            if let image = imageViewMeme.image {
                
                let ratioWidth = imageViewMeme.frame.width / image.size.width
                let ratioHeight = imageViewMeme.frame.height / image.size.height
                
                let ratio = ratioWidth < ratioHeight ? ratioWidth : ratioHeight
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
             
                let left = 0.5 * (newWidth * scrollView.zoomScale > imageViewMeme.frame.width ? (newWidth - imageViewMeme.frame.width):(scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageViewMeme.frame.height ? (newHeight - imageViewMeme.frame.height):(scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
            
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
        
    }
    
}
