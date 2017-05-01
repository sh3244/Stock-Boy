//
//  TextField.swift
//  Stock Boy
//
//  Created by Sam on 4/27/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class TextField: UITextField {

  override init(frame: CGRect) {
    super.init(frame: frame)
    textColor = UISettings.foregroundColor
    textAlignment = .center
    backgroundColor = UISettings.neutralColor
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  convenience init(_ title: String) {
    self.init(frame: .zero)
    self.text = title
  }

  convenience init(placeholder: String) {
    self.init(frame: .zero)
    self.placeholder = placeholder
  }

}
