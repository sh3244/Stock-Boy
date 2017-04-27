//
//  LoginViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class LoginViewController: ViewController {
  let titleLabel = Label("Robinhood")
  let usernameLabel = Label("Username")
  let username = TextField("sh3244")
  let passwordLabel = Label("Password")
  let password = TextField("5ezypqj9omp")
  let login = Button("Login")
  let logout = Button("Button")

  let loginStatus = StatusView("Not Logged In", color: .red)

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Login"

    titleLabel.setTypeTitle()

    login.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
    logout.addTarget(self, action: #selector(performLogout), for: .touchUpInside)
  }

  override func viewWillLayoutSubviews() {
    view.sv([loginStatus, username, password, login, titleLabel, usernameLabel, passwordLabel, logout])

    equalWidths(login, logout)

    view.layout(
      8,
      |loginStatus| ~ 40,
      8,
      |titleLabel| ~ 40,
      20,
      |usernameLabel| ~ 40,
      |username| ~ 40,
      8,
      |passwordLabel| ~ 40,
      |password| ~ 40,
      8,
      |login-logout| ~ 40
    )
  }

  func performLogout() {
    LoginManager.shared.logout {
      self.loginStatus.reset()
    }
  }

  func performLogin() {
    if username.text?.validateName() ?? false && password.text?.validatePassword() ?? false {
      LoginManager.shared.loginWith(username: username.text!, password: password.text!) { (auth) in
        self.loginStatus.title.text = "Logged In"
        self.loginStatus.backgroundColor = .green
      }
    }
  }

}
