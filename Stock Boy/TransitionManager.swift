//
//  TransitionManager.swift
//  Stock Boy
//
//  Created by Sam on 4/28/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIScrollViewDelegate {
  static let shared: TransitionManager = {
    let instance = TransitionManager()

    return instance
  }()

  var shouldAnimate = true

  func begin() {
    shouldAnimate = false
  }

  func end() {
    shouldAnimate = true
  }
}
