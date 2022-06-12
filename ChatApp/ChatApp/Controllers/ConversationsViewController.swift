//
//  ConversationsViewController.swift
//  ChatApp
//
//  Created by 윤병일 on 2022/06/12.
//

import UIKit

class ConversationsViewController: UIViewController {

  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
    
    if !isLoggedIn {
      let vc = LoginViewController()
      let navi = UINavigationController(rootViewController: vc)
      navi.modalPresentationStyle = .fullScreen
      present(navi, animated: false)
    }
  }

  //MARK: - Functions
  private func configureUI() {
    view.backgroundColor = .red
  }
}

