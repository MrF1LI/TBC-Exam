//
//  RegisterViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 19.08.22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldCourse: UITextField!
    @IBOutlet weak var textFieldFaculty: UITextField!
    
    @IBOutlet weak var buttonMale: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    
    // MARK: - Variables
    
    private let arrayOfCourses = ["I Course", "II Course", "III Course", "IV Course"]
    private let arrayOfFaculties = ["Information Technologies", "Management", "Finance", "Digital Marketing"]
    
    private var profileImageData: Data?
    
    private var datePicker = UIDatePicker()
    private var coursePicker = UIPickerView()
    private var facultyPicker = UIPickerView()
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        configurePickers()
        fillForm()
    }
    
    // MARK: - Private Methods
    
    private func configureDesign() {
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
    
    private func fillForm() {
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
        
        FirebaseManager().signUp(with: formData, profileImageData: profileImageData) { [weak self] error, databaseReference in
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
    
    // MARK: - Other Functinos
    
    func showRegisterFailedAlert(message: String) {
        let alert = UIAlertController(title: "Registration Failed", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        
    }
    
    // MARK: - Navigation Functions
    
    func goToMainPage() {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController")
        guard let navController = navController else { return }

        view.window?.rootViewController = navController
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extension for configure pickers

extension RegisterViewController {
    
    func configurePickers() {
        configureDatePicker()
        configureCoursePicker()
        configureFacultyPicker()
        configureProfileImageView()
    }
    
    func configureDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionDatePicker))
        toolbar.setItems([buttonDone], animated: true)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        textFieldDate.inputAccessoryView = toolbar
        textFieldDate.inputView = datePicker
        
    }
    
    func configureCoursePicker() {
        coursePicker.delegate = self
        coursePicker.dataSource = self
        textFieldCourse.inputView = coursePicker
        coursePicker.tag = 1
    }
    
    func configureFacultyPicker() {
        facultyPicker.delegate = self
        facultyPicker.dataSource = self
        textFieldFaculty.inputView = facultyPicker
        facultyPicker.tag = 2
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func configureProfileImageView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionImageViewProfile))
        imageViewProfile.addGestureRecognizer(gesture)
        imageViewProfile.contentMode = .scaleAspectFill
    }
    
    // MARK: - Actions
    
    @objc func actionDatePicker() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        textFieldDate.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func actionImageViewProfile() {
        showImagePicker()
    }
    
}

// MARK: - Extension for course and faculty pickers

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return arrayOfCourses.count
        } else {
            return arrayOfFaculties.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return arrayOfCourses[row]
        } else {
            return arrayOfFaculties[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            textFieldCourse.text = arrayOfCourses[row]
            textFieldCourse.resignFirstResponder()
        } else {
            textFieldFaculty.text = arrayOfFaculties[row]
            textFieldFaculty.resignFirstResponder()
        }
    }

}

// MARK: - Extension for image picker

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
    
        guard let imageData = image.pngData() else {
            return
        }
        
        profileImageData = imageData
        imageViewProfile.image = image
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
