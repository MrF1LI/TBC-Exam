//
//  Extensions.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import FirebaseDatabase
import UIKit

enum CornerStyle {
    case capsule
    case item
}

extension UIView {
    
    func setCornerStyle(_ style: CornerStyle) {
        if style == .capsule {
            self.layer.cornerRadius = self.frame.width / 2
        } else {
            self.layer.cornerRadius = 35
        }
    }
    
}

extension Date {
    func getAge() -> Int {
        return Int(Calendar.current.dateComponents([.year], from: self, to: Date()).year!)
    }
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        if self.description == Date().description {
            return "ახლახანს"
        }
        
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

extension UITableViewCell {
    func configureTableDesign() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        self.selectionStyle = .none
    }
}

// MARK: - CollectionView

extension UICollectionView {
    func configure(with cell: String, for viewController: UICollectionViewDelegate & UICollectionViewDataSource, cornerStyle: CornerStyle?) {
        self.delegate = viewController
        self.dataSource = viewController
        self.register(UINib(nibName: cell, bundle: nil), forCellWithReuseIdentifier: cell)

        if let cornerStyle = cornerStyle {
            self.setCornerStyle(cornerStyle)
        }
    }
}

// MARK: - Spinner

extension UIViewController {
    
    func showSpinner() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = UIScreen.main.bounds
        view.addSubview(blurredEffectView)
        
        let activityView = UIActivityIndicatorView()
        activityView.style = .large
        activityView.color = .systemPink
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityView.startAnimating()
    }
    
}

// MARK: - Textfield

extension UITextField {
    
    func setCapsuledStyle() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.tintColor = .colorSecondary
    }
    
    func setHorizontalPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        self.leftViewMode = .always
        self.leftView = paddingView
        
        self.rightViewMode = .always
        self.leftView = paddingView
    }
    
    func setLeftView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20)) // set your Own size
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
}

// MARK: - Firebase decode

extension DataSnapshot {
    
    func decode<T: Codable>(class: T.Type) -> T? {
        do {
            var data: Data? {
                guard let value = self.value, !(value is NSNull) else { return nil }
                return try? JSONSerialization.data(withJSONObject: value)
            }
            
            guard let data = data else { return nil }
            
            //
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            //
                            
            let object = try decoder.decode(T.self, from: data)
            return object
                       
        } catch {
            print("Decoding error.", error)
            return nil
        }
    }
        
}

// MARK: - Colors

extension UIColor {
    open class var colorBTU: UIColor { UIColor(named: "BTU Color") ?? .white }
    open class var colorBackground: UIColor { UIColor(named: "Background Color") ?? .white }
    open class var colorItem: UIColor { UIColor(named: "Item Color") ?? .white }
    open class var colorPrimary: UIColor { UIColor(named: "Text Primary Color") ?? .white }
    open class var colorSecondary: UIColor { UIColor(named: "Text Secondary Color") ?? .white }
    open class var extraLightGreen: UIColor { UIColor(named: "Extra Light Green") ?? .white }
    open class var lightGreen: UIColor { UIColor(named: "Light Green") ?? .white }
    open class var green: UIColor { UIColor(named: "Green") ?? .white }
    open class var darkGreen: UIColor { UIColor(named: "Dark Green") ?? .white }
    open class var yellow: UIColor { UIColor(named: "Yellow") ?? .white }
    open class var darkYellow: UIColor { UIColor(named: "Dark Yellow") ?? .white }
    open class var orange: UIColor { UIColor(named: "Orange") ?? .white }
    open class var darkOrange: UIColor { UIColor(named: "Dark Orange") ?? .white }
    open class var red: UIColor { UIColor(named: "Red") ?? .white }
    open class var darkRed: UIColor { UIColor(named: "Dark Red") ?? .white }
}
