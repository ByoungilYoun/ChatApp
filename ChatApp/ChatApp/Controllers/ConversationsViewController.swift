//
//  ConversationsViewController.swift
//  ChatApp
//
//  Created by 윤병일 on 2022/06/12.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    validateAuth()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    validateAuth()
  }

  //MARK: - Functions
  private func configureUI() {
    view.backgroundColor = .red
  }
  
  private func validateAuth() {
    print("하하 여길탐?")
    if FirebaseAuth.Auth.auth().currentUser != nil {
      print("하하 여길탐2")
      let vc = LoginViewController()
      let navi = UINavigationController(rootViewController: vc)
      navi.modalPresentationStyle = .fullScreen
      present(navi, animated: false)
    }
  }
}

