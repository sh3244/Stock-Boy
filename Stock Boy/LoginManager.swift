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

  static let shared: LoginManager = {
    let instance = LoginManager()

    return instance
  }()

  func loginWith(username: String, password: String) {
    DataManager.shared.fetchRobinhoodAuthWith(completion: )
  }

}
