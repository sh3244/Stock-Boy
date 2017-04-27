//
//  LoginManager.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Argo
import Alamofire
import RxSwift

//https://github.com/sanko/Robinhood

class LoginManager: NSObject {
  var loggedIn = false
  var auth: Auth?

  static let shared: LoginManager = {
    let instance = LoginManager()

    return instance
  }()

  func loginWith(username: String, password: String, completion:@escaping ((Auth) -> Void)) {
    DataManager.shared.fetchRobinhoodAuthWith(username: username, password: password) { (auth) in
      self.auth = auth
      self.loggedIn = true
      completion(auth)
    }
  }

  func logout(completion:@escaping (() -> Void)) {
    self.auth = nil
    self.loggedIn = false
    completion()
  }

}
