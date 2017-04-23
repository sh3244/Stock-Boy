//
//  Button.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class Button: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .black
    titleLabel?.textColor = .white
    titleLabel?.highlightedTextColor = .red
    showsTouchWhenHighlighted = true
//    translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
