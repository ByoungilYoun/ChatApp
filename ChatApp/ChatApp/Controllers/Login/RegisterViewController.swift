//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by 윤병일 on 2022/06/12.
//

import UIKit
import FirebaseAuth

class RegisterViewController : UIViewController {
  
  //MARK: - Properties
  
  private let scrollView : UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.clipsToBounds = true
    scrollView.isUserInteractionEnabled = true
    return scrollView
  }()
  
  private let imageView : UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "person")
    imageView.tintColor = .gray
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.lightGray.cgColor
    return imageView
  }()
  
  private let firstNameField : UITextField = {
    let field = UITextField()
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.returnKeyType = .continue
    field.layer.cornerRadius = 12
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.placeholder = "First Name.."
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    field.leftViewMode = .always
    field.backgroundColor = .white
    return field
  }()
  
  private let lastNameField : UITextField = {
    let field = UITextField()
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.returnKeyType = .continue
    field.layer.cornerRadius = 12
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.placeholder = "Last Name.."
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    field.leftViewMode = .always
    field.backgroundColor = .white
    return field
  }()
  
  private let emailField : UITextField = {
    let field = UITextField()
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.returnKeyType = .continue
    field.layer.cornerRadius = 12
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.placeholder = "Email Address.."
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    field.leftViewMode = .always
    field.backgroundColor = .white
    return field
  }()
  
  private let passwordField : UITextField = {
    let field = UITextField()
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.returnKeyType = .done
    field.layer.cornerRadius = 12
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.placeholder = "Password"
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    field.leftViewMode = .always
    field.backgroundColor = .white
    field.isSecureTextEntry = true
    return field
  }()
  
  
  private let registerButton : UIButton = {
    let button = UIButton()
    button.setTitle("Register", for: .normal)
    button.backgroundColor = .systemGreen
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 12
    button.layer.masksToBounds = true
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    return button
  }()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavi()
    configureUI()
  }
  
  //MARK: - Functions
  private func configureNavi() {
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
    view.backgroundColor = .white
  }
  
  private func configureUI() {
    view.addSubview(scrollView)
    scrollView.frame = view.bounds
    [imageView, firstNameField, lastNameField, emailField, passwordField, registerButton].forEach {
      scrollView.addSubview($0)
    }
    
    [firstNameField, lastNameField, emailField, passwordField].forEach {
      $0.delegate = self
    }
    
    registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    
    let gesture = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapChangeProfilePic))
    gesture.numberOfTouchesRequired = 1
    gesture.numberOfTapsRequired = 1
    imageView.addGestureRecognizer(gesture)
    
    let size = scrollView.width / 3
    imageView.frame = CGRect(x: (view.width - size)/2, y: 40, width: size, height: size)
    imageView.layer.cornerRadius = imageView.width / 2.0
    
    firstNameField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width - 60, height: 52)
    lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom + 10, width: scrollView.width - 60, height: 52)
    emailField.frame = CGRect(x: 30, y: lastNameField.bottom + 10, width: scrollView.width - 60, height: 52)
    passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width - 60, height: 52)
    registerButton.frame = CGRect(x: 30, y: passwordField.bottom + 10, width: scrollView.width - 60, height: 52)
  }
  
  private func alertUserLoginError() {
    let alert = UIAlertController(title: "Woops",
                                  message: "Please enter all information to create a new account.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss",
                                  style: .cancel,
                                  handler: nil))
    present(alert, animated: true)
  }
  
  //MARK: - @objc func
  
  @objc private func didTapRegister() {
    let vc = RegisterViewController()
    vc.title = "Create Account"
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc private func registerButtonTapped() {
    firstNameField.resignFirstResponder()
    lastNameField.resignFirstResponder()
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
    
    guard let firstName = firstNameField.text,
          let lastName = lastNameField.text,
          let email = emailField.text,
          let password = passwordField.text,
          !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
      alertUserLoginError()
      return
    }
    
    // Todo : Firebase Register
    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      guard let result = authResult, error == nil else {
        print("Error creating user : \(error?.localizedDescription)")
        return
      }
      
      let user = result.user
      print("Created user : \(user)")
    }
  }
  
  @objc private func didTapChangeProfilePic() {
    presentPhotoActionSheet()
  }
}

 //MARK: - UITextFieldDelegate
extension RegisterViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == firstNameField {
      lastNameField.becomeFirstResponder()
    } else if textField == lastNameField {
      emailField.becomeFirstResponder()
    } else if textField == emailField {
      passwordField.becomeFirstResponder()
    } else if textField == passwordField {
      registerButtonTapped() // 자동으로 버튼 클릭되게끔
    }
    
    return true
  }
}

  //MARK: - UIImagePickerControllerDelegate
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func presentPhotoActionSheet() {
    let actionSheet = UIAlertController(title: "Profile Picture",
                                        message: "How would you like to select a picture?",
                                        preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Cancel",
                                        style: .cancel,
                                        handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                        style: .default,
                                        handler: { [weak self] _ in
      self?.presentCamera()
    }))
    actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                        style: .default,
                                        handler: { [weak self] _ in
      self?.presentPhotoPicker()
    }))
    present(actionSheet, animated: true)
  }
  
  func presentCamera() {
    let vc = UIImagePickerController()
    vc.sourceType = .camera
    vc.delegate = self
    vc.allowsEditing = true
    present(vc, animated: true)
  }
  
  func presentPhotoPicker() {
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.delegate = self
    vc.allowsEditing = true
    present(vc, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true)
    guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
      return
    }
    
    self.imageView.image = selectedImage
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { // cancel 버튼 눌렀을때
    picker.dismiss(animated: true)
  }
}
