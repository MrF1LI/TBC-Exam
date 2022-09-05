//
//  LecturerViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import UIKit

class LecturerViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imageViewRecomended: UIImageView!
    @IBOutlet weak var viewRatingBackground: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelRatesCount: UILabel!
    @IBOutlet weak var lecturerRating: CosmosView!
    
    @IBOutlet weak var progressExcellent: GradientProgressView!
    @IBOutlet weak var progressGood: GradientProgressView!
    @IBOutlet weak var progressAverage: GradientProgressView!
    @IBOutlet weak var progressBelowAverage: GradientProgressView!
    @IBOutlet weak var progressPoor: GradientProgressView!
    
    @IBOutlet weak var tableViewReviews: UITableView!
    @IBOutlet weak var tableViewReviewsHeight: NSLayoutConstraint!
    @IBOutlet weak var labelReviewTitle: UILabel!
    
    @IBOutlet weak var textFieldReview: UITextField!
    @IBOutlet weak var addReviewBackground: UIView!
    @IBOutlet weak var addReviewBackgroundConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    
    var lecturer: Lecturer!
    
    var arrayOfReviews = [Review]()
    
    var loaded = false
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        configureNavigationBar()
        loadLecturerInfo()
        configureRatingView()
        loadReviews()
        listenToKeyboard()
    }
    
    // MARK: - Functions
    
    func configureDesign() {
        
        imageViewProfile.setCornerStyle(.capsule)
        viewRatingBackground.setCornerStyle(.item)
        
        progressExcellent.layer.cornerRadius = 8
        progressExcellent.clipsToBounds = true
        
        progressExcellent.firstColor = .green
        progressExcellent.secondColor = .darkGreen
        
        progressGood.layer.cornerRadius = 8
        progressGood.clipsToBounds = true
        
        progressGood.firstColor = .extraLightGreen
        progressGood.secondColor = .lightGreen
        
        progressAverage.layer.cornerRadius = 8
        progressAverage.clipsToBounds = true
        
        progressAverage.firstColor = .yellow
        progressAverage.secondColor = .darkYellow
        
        progressBelowAverage.layer.cornerRadius = 8
        progressBelowAverage.clipsToBounds = true
        
        progressBelowAverage.firstColor = .orange
        progressBelowAverage.secondColor = .darkOrange
        
        progressPoor.layer.cornerRadius = 8
        progressPoor.clipsToBounds = true
        
        progressPoor.firstColor = .red
        progressPoor.secondColor = .darkRed
        
        tableViewReviews.configure(with: "ReviewCell", for: self, cornerStyle: .item)
        
        //
        
        scrollView.delegate = self
        
        textFieldReview.setCapsuledStyle()
        textFieldReview.setHorizontalPadding()
        
        addReviewBackground.layer.shadowOffset = CGSize(width: 0,
                                          height: -10)
        addReviewBackground.layer.shadowRadius = 10
        addReviewBackground.layer.shadowOpacity = 0.1
        
        //
    }
    
    func configureNavigationBar() {
        let buttonBack = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        
        let buttonIcon = UIImage(systemName: "arrow.backward")
        buttonBack.setImage(buttonIcon, for: .normal)
        buttonBack.layer.cornerRadius = 35/2
        
        buttonBack.tintColor = .colorPrimary
        buttonBack.backgroundColor = .colorItem
        
        buttonBack.addTarget(self, action: #selector(actionGoBack), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func loadLecturerInfo() {
        guard let lecturer = lecturer else { return }
        
        labelFullName.text = "\(lecturer.name) \(lecturer.surname)"
        labelEmail.text = lecturer.email
        
        imageViewProfile.sd_setImage(with: URL(string: lecturer.profile),
                                          placeholderImage: UIImage(named: "user"),
                                          options: .continueInBackground,
                                          completed: nil)
        
        loadRating()
    }
    
    func loadRating() {
        guard let rates = lecturer.rates else { return }
        let rating = lecturer.getRating()
        labelRating.text = String(format: "%.1f", rating)
        labelRatesCount.text = "Based on \(rates.count) rates"
        
        lecturerRating.rating = Double(rating)
        imageViewRecomended.isHidden = !lecturer.isRecomended()
        
        //
        
        UIView.transition(with: imageViewRecomended,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { self.imageViewRecomended.isHidden = !self.lecturer.isRecomended() },
                          completion: nil)
        
        //
        
        let ratingDetails = lecturer.getRatingDetails()
        guard let ratingDetails = ratingDetails else { return }
        
        progressExcellent.setProgress(ratingDetails.excellent, animated: true)
        progressGood.setProgress(ratingDetails.good, animated: true)
        progressAverage.setProgress(ratingDetails.average, animated: true)
        progressBelowAverage.setProgress(ratingDetails.belowAverage, animated: true)
        progressPoor.setProgress(ratingDetails.poor, animated: true)
    }
    
    func configureRatingView() {
        guard let lecturer = lecturer else { return }

        lecturerRating.didFinishTouchingCosmos = { rate in
            FirebaseManager.shared.rate(lecturer: lecturer, by: rate) { [weak self] in
                self?.getLecturerRating()
            }
        }
    }
    
    func getLecturerRating() {
        
        guard let lecturer = lecturer else { return }

        FirebaseManager.shared.fetchRating(of: lecturer) { [weak self] ratingData, arrayOfRates, rating in
            self?.lecturer.rates = ratingData
            self?.loadRating()
        }
        
    }
    
    func loadReviews() {
        
        FirebaseManager.shared.fetchReviews(of: lecturer) { [weak self] arrayOfReviews in
            self?.arrayOfReviews = arrayOfReviews
            self?.labelReviewTitle.isHidden = arrayOfReviews.isEmpty
            self?.tableViewReviews.reloadData()
        }
        
    }
    
    // MARK: Actions
    
    @objc func actionGoBack() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func actionAddReview(_ sender: UIButton) {
        
        guard let lecturer = lecturer else { return }
        guard let review = textFieldReview.text else { return }
        
        FirebaseManager.shared.review(lecturer: lecturer, with: review) {
            self.textFieldReview.text = ""
        }
        
    }
    
}

extension LecturerViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        loaded = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if loaded {
            if isVisible(view: labelFullName) {
                self.title = ""
            } else {
                self.title = "\(lecturer.name) \(lecturer.surname)"
            }
        }
        
    }
    
    func isVisible(view: UIView) -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view: view, inView: view.superview)
    }
    
}

// MARK: For keyboard

extension LecturerViewController {
    
    func listenToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        
        if #available(iOS 11.0, *){
            self.addReviewBackgroundConstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom
        }
        else {
            self.addReviewBackgroundConstraint.constant = view.safeAreaInsets.bottom
        }
        
        UIView.animate(withDuration: 0.5){ [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        self.addReviewBackgroundConstraint.constant =  0 // or change according to your logic
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
    }
    
}
