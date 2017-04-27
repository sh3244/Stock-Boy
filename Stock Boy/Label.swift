//
//  Label.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class Label: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    textColor = .white
    textAlignment = .center
    font = UIFont.systemFont(ofSize: 14)
//    translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  convenience init(_ title: String) {
    self.init(frame: .zero)
    text = title
  }

  func setTypeTitle() {
    font = UIFont.systemFont(ofSize: 20)
  }

  func changeTextTo(value: String) {
    if text != value {
      UIView.animate(withDuration: 1, animations: { 
        self.text = value
      })
    }
  }

}
