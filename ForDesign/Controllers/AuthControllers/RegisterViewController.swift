//
//  RegisterViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 19.08.22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldCourse: UITextField!
    @IBOutlet weak var textFieldFaculty: UITextField!
    
    @IBOutlet weak var buttonMale: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    
    // MARK: Variables
    
    let arrayOfCourses = ["I Course", "II Course", "III Course", "IV Course"]
    let arrayOfFaculties = ["Information Technologies", "Management", "Finance", "Digital Marketing"]
    
    var profileImageData: Data?
    
    var datePicker = UIDatePicker()
    var coursePicker = UIPickerView()
    var facultyPicker = UIPickerView()
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        configurePickers()
        fillForm()
    }
    
    func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)

        textFieldName.setCapsuledStyle()
        textFieldName.setLeftView(image: UIImage(named: "user") ?? .checkmark)
        
        textFieldSurname.setCapsuledStyle()
        textFieldSurname.setHorizontalPadding()
        
        textFieldDate.setCapsuledStyle()
        textFieldDate.setLeftView(image: UIImage(named: "calendar") ?? .checkmark)
        
        textFieldCourse.setCapsuledStyle()
        textFieldCourse.setLeftView(image: UIImage(named: "course") ?? .checkmark)
        
        textFieldFaculty.setCapsuledStyle()
        textFieldFaculty.setLeftView(image: UIImage(named: "faculty") ?? .checkmark)
    }
    
    func fillForm() {
        let currentUser = FirebaseManager.currentUser
        let userFullName = currentUser?.displayName?.components(separatedBy: " ")
        let userProfilePicture = currentUser?.photoURL
        
        textFieldName.text = userFullName?.first
        textFieldSurname.text = userFullName?.last
        
        imageViewProfile.sd_setImage(with: URL(string: userProfilePicture?.absoluteString ?? ""),
                                     placeholderImage: UIImage(named: "user.default"),
                                     options: .continueInBackground,
                                     completed: nil)
                
    }
    
    // MARK: - Actions
    
    @IBAction func actionRegister(_ sender: UIButton) {
        
        self.showSpinner()
        
        guard let name = textFieldName.text, !name.isEmpty,
              let surname = textFieldSurname.text, !surname.isEmpty,
              let dateText = textFieldDate.text, !dateText.isEmpty,
              let course = textFieldCourse.text, !course.isEmpty,
              let faculty = textFieldFaculty.text, !faculty.isEmpty
        else {
            showRegisterFailedAlert(message: "Please fill form.")
            return
        }
        
        let date = DateFormatter.localizedString(from: datePicker.date, dateStyle: .short, timeStyle: .none)
        
        var formData: [String:Any] = [
            "name": name,
            "surname": surname,
            "date": date,
            "age": datePicker.date.getAge(),
            "course": course,
            "faculty": faculty
        ]
        
        if buttonMale.isSelected || buttonFemale.isSelected {
            formData["sex"] = buttonMale.isSelected ? "Male" : "Female"
        }
        
        FirebaseManager.shared.signUp(with: formData, profileImageData: profileImageData) { [weak self] error, databaseReference in
            guard error == nil else {
                self?.showRegisterFailedAlert(message: "Can't register user.")
                return
            }
            
            self?.goToMainPage()
        }
    }

    @IBAction func actionMale(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            buttonFemale.isSelected = false
        } else {
            sender.isSelected = true
            buttonFemale.isSelected = false
        }
    }
    
    @IBAction func actionFemale(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            buttonMale.isSelected = false
        } else {
            sender.isSelected = true
            buttonMale.isSelected = false
        }
    }
    
    // MARK: - Functinos
    
    func showRegisterFailedAlert(message: String) {
        let alert = UIAlertController(title: "Registration Failed", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        
    }
    
    // MARK: Navigation Functions
    
    func goToMainPage() {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController")
        guard let navController = navController else { return }

        view.window?.rootViewController = navController
        navigationController?.popViewController(animated: true)
    }
    
}
