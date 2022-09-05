//
//  EditProfileViewController.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 25.08.22.
//

import UIKit
import SwiftUI

class EditProfileViewController: UIViewController {
    
    // MARK: Variables
    
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldBirthDate: UITextField!
    @IBOutlet weak var textFieldCourse: UITextField!
    @IBOutlet weak var textFieldFaculty: UITextField!
    
    @IBOutlet weak var buttonMale: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    
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
    
    func configureDesign() {
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
    
    func fillForm() {
        
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
    
    func updateUserInfo(with data: [String:Any]) {
        
        if let profileImageData = profileImageData {
            FirebaseManager.shared.uploadProfilePicture(imageData: profileImageData)
        }
        
        FirebaseManager.shared.updateUserProfile(with: data) { [weak self] in
            NotificationCenter.default.post(name: Notification.Name("profileInfoUpdated"), object: nil)
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
