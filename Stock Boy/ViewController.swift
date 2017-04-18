//
//  ViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .gray
  }

  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    }
    return false
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    return true
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    textField.text = ""
    return true
  }
}
