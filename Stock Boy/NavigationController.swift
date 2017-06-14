//
//  NavigationController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.barStyle = .black
    navigationBar.isTranslucent = false
    navigationBar.tintColor = UISettings.foregroundColor
  }
}
