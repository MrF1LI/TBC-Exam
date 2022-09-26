//
//  EditProfileViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 25.08.22.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldBirthDate: UITextField!
    @IBOutlet weak var textFieldCourse: UITextField!
    @IBOutlet weak var textFieldFaculty: UITextField!
    
    @IBOutlet weak var buttonMale: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    
    // MARK: - Variables
    
    var datePicker = UIDatePicker()
    var coursePicker = UIPickerView()
    var facultyPicker = UIPickerView()
    
    var arrayOfCourses = ["I Course", "II Course", "III Course", "IV Course"]
    var arrayOfFaculties = ["Information Technologies", "Management", "Finance", "Digital Marketing"]
    
    var user: User?
    
    var profileImageData: Data?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        configurePickers()
        fillForm()
    }
    
    private func configureDesign() {
        imageViewProfile.setCornerStyle(.capsule)

        textFieldName.setCapsuledStyle()
        textFieldName.setLeftView(image: UIImage(named: "user") ?? .checkmark)
        
        textFieldSurname.setCapsuledStyle()
        textFieldSurname.setHorizontalPadding()
        
        textFieldBirthDate.setCapsuledStyle()
        textFieldBirthDate.setLeftView(image: UIImage(named: "calendar") ?? .checkmark)
        
        textFieldCourse.setCapsuledStyle()
        textFieldCourse.setLeftView(image: UIImage(named: "course") ?? .checkmark)
        
        textFieldFaculty.setCapsuledStyle()
        textFieldFaculty.setLeftView(image: UIImage(named: "faculty") ?? .checkmark)
    }
    
    private func fillForm() {
        
        FirebaseManager.shared.fetchUserInfo(by: FirebaseManager.currentUser!.uid) { [weak self] user, userInfo in
            
            self?.user = user
            
            self?.textFieldName.text = user.name
            self?.textFieldSurname.text = user.surname
            self?.textFieldCourse.text = user.course
            self?.textFieldFaculty.text = user.faculty
            
            self?.imageViewProfile.sd_setImage(with: URL(string: user.profile),
                                              placeholderImage: UIImage(named: "user.default"),
                                              options: .continueInBackground,
                                              completed: nil)
            
            // Date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short

            let dateObj = dateFormatter.date(from: user.date)

            self?.datePicker.date = dateObj ?? Date.now
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            
            self?.textFieldBirthDate.text = formatter.string(from: self?.datePicker.date ?? Date.now)
            
            // Gender
            
            if user.gender == .male{
                self?.buttonMale.isSelected = true
                self?.buttonFemale.isSelected = false
            } else {
                self?.buttonFemale.isSelected = true
                self?.buttonMale.isSelected = false
            }
            
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func actionSave(_ sender: UIButton) {
        
        guard let name = textFieldName.text, !name.isEmpty,
              let surname = textFieldSurname.text, !surname.isEmpty,
              let dateText = textFieldBirthDate.text, !dateText.isEmpty,
              let course = textFieldCourse.text, !course.isEmpty,
              let faculty = textFieldFaculty.text, !faculty.isEmpty
        else {
            print("Fill Form.")
            return
        }
        
        var userData = [String:Any]()
        
        if name != self.user?.name { userData["name"] = name }
        if dateText != self.user?.date { userData["date"] = dateText }
        if surname != self.user?.surname { userData["surname"] = surname }
        if course != self.user?.course { userData["course"] = course }
        if faculty != self.user?.faculty { userData["faculty"] = faculty }
        
        let gender: Gender = buttonMale.isSelected ? .male : .female
        if gender != self.user?.gender {
            userData["gender"] = gender.rawValue
        }
        
        updateUserInfo(with: userData)
        
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
    
    // MARK: - Other functions
    
    private func updateUserInfo(with data: [String:Any]) {
        
        if let profileImageData = profileImageData {
            FirebaseManager.shared.uploadProfilePicture(imageData: profileImageData)
        }
        
        // TODO: - Refactor MVVM
        
        FirebaseManager.shared.updateUserProfile(with: data) { [weak self] in
            NotificationCenter.default.post(name: Notification.Name("profileInfoUpdated"), object: nil)
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
    
}

// MARK: - Extension for configure pickers

extension EditProfileViewController {
    
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

        textFieldBirthDate.inputAccessoryView = toolbar
        textFieldBirthDate.inputView = datePicker
        
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
        
        textFieldBirthDate.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func actionImageViewProfile() {
        showImagePicker()
    }
    
}

// MARK: - Extension for course and faculty pickers

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
