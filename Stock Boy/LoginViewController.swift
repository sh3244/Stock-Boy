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
  let titleLabel = Label("Robinhood", type: .title)
  let usernameLabel = Label("Username")
  let username = TextField("")
  let passwordLabel = Label("Password")
  let password = TextField("")
  let login = Button("Login")
  let logout = Button("Logout")

  let cancel = Button("Cancel All Orders")

  let loginStatus = StatusView("Not logged in", .red)

  override func viewDidLoad() {
    super.viewDidLoad()

    password.isSecureTextEntry = true
    username.delegate = self
    password.delegate = self

    cancel.setTitleColor(.red, for: .normal)

    login.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
    logout.addTarget(self, action: #selector(performLogout), for: .touchUpInside)
    cancel.addTarget(self, action: #selector(cancelOrders), for: .touchUpInside)

    let defaults = UserDefaults.standard
    if let username = defaults.string(forKey: "username"), let password = defaults.string(forKey: "password") {
      LoginManager.shared.loginWith(username: username, password: password) { (auth) in
        self.loginStatus.title.text = "Logged in as " + username
        self.loginStatus.backgroundColor = .green
        if let controller = self.tabBarController {
          self.navigationController?.popViewController(animated: true)
          controller.selectedViewController = controller.viewControllers?.first
        }
      }
    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([loginStatus, username, password, login, titleLabel, usernameLabel, passwordLabel, logout, cancel])

    equalWidths(login, logout)

    view.layout(
      20,
      |titleLabel| ~ 40,
      8,
      |loginStatus| ~ 40,
      20,
      |usernameLabel| ~ 40,
      |username| ~ 40,
      8,
      |passwordLabel| ~ 40,
      |password| ~ 40,
      8,
      |login-logout| ~ 40,
      120,
      |cancel| ~ 40
    )
  }

  func performLogout() {
    LoginManager.shared.logout {
      self.loginStatus.reset()
      let defaults = UserDefaults.standard
      defaults.setValue("", forKey: "username")
      defaults.setValue("", forKey: "password")
    }
  }

  func performLogin() {
    if username.text?.validateName() ?? false && password.text?.validatePassword() ?? false {
      LoginManager.shared.loginWith(username: username.text!, password: password.text!) { (auth) in
        self.loginStatus.title.text = "Logged in as " + self.username.text!
        self.loginStatus.backgroundColor = .green
        let defaults = UserDefaults.standard
        defaults.setValue(self.username.text!, forKey: "username")
        defaults.setValue(self.password.text!, forKey: "password")
      }
    }
  }

  func cancelOrders() {
    if let auth = LoginManager.shared.auth {
      DataManager.shared.cancelAllRobinhoodOrdersWith(auth: auth)
    }
  }

  override func textFieldDidBeginEditing(_ textField: UITextField) {
    super.textFieldDidBeginEditing(textField)
    textField.returnKeyType = .done
  }

  override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if super.textFieldShouldReturn(textField) {
      performLogin()
    }
    return false
  }

}
