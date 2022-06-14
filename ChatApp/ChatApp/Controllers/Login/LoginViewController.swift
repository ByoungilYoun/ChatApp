//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 윤병일 on 2022/06/12.
//

import UIKit
import FirebaseAuth

class LoginViewController : UIViewController {
  
  //MARK: - Properties
  
  private let scrollView : UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.clipsToBounds = true
    return scrollView
  }()
  
  private let imageView : UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "logo")
    imageView.contentMode = .scaleAspectFit
    return imageView
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
  
  private let loginButton : UIButton = {
    let button = UIButton()
    button.setTitle("Log In", for: .normal)
    button.backgroundColor = .link
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
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    configureUI()
  }
  
  //MARK: - Functions
  private func configureNavi() {
    title = "Log In"
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
    view.backgroundColor = .white
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(didTapRegister))
  }
  
  private func configureUI() {
    view.addSubview(scrollView)
    scrollView.frame = view.bounds
    [imageView, emailField, passwordField, loginButton].forEach {
      scrollView.addSubview($0)
    }
    
    [emailField, passwordField].forEach {
      $0.delegate = self
    }
    
    loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    
    let size = scrollView.width / 3
    imageView.frame = CGRect(x: (view.width - size)/2, y: 50, width: size, height: size)
    emailField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width - 60, height: 52)
    passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width - 60, height: 52)
    loginButton.frame = CGRect(x: 30, y: passwordField.bottom + 10, width: scrollView.width - 60, height: 52)
  }
  
  private func alertUserLoginError() {
    let alert = UIAlertController(title: "Woops",
                                  message: "Please enter all information to log in.", preferredStyle: .alert)
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
  
  @objc private func loginButtonTapped() {
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
    
    guard let email = emailField.text,
          let password = passwordField.text,
          !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
    }
    
    // Todo : Firebase Log In
    FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
      guard let self = self else { return }
      
      guard let result = authResult, error == nil else {
        print("Failed to log in user with email : \(email)")
        return
      }
      let user = result.user
      print("Logged in user : \(user)")
      
      self.navigationController?.dismiss(animated: true, completion: nil)
    })
  }
}

  //MARK: - UITextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == emailField {
      passwordField.becomeFirstResponder()
    } else if textField == passwordField {
      loginButtonTapped() // 자동으로 버튼 클릭되게끔
    }
    
    return true
  }
}
