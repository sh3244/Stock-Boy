//
//  StatusView.swift
//  Stock Boy
//
//  Created by Sam on 4/27/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class StatusView: View {
  let title = Label("status")
  var resetTitle = "status"
  var resetColor = UIColor.gray

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .gray
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  convenience init(_ title: String, color: UIColor) {
    self.init(frame: .zero)
    self.title.text = title
    self.backgroundColor = color
    self.resetTitle = title
    self.resetColor = color
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    sv(title)
    title.fillContainer()
  }

  func reset() {
    self.title.text = resetTitle
    self.backgroundColor = resetColor
  }

}
