//
//  QuoteCell.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class QuoteCell: UITableViewCell {
  var symbol = Label()
  var price = Label()
  var change = Label()
  var indicator = UIView()

  public static let heightValue: CGFloat = 80.0
  let height: CGFloat = 80.0

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    price.text = "$$$"

    backgroundColor = .black
    sv([symbol, price, change, indicator])
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    indicator.width(40)
    layout(
      0,
      |-symbol-indicator-| ~ 40,
      |-price-change-| ~ 40,
      0
    )
  }

  override func prepareForReuse() {
    subviews.forEach { (view) in
      view.removeFromSuperview()
    }
  }

  func apply(color: UIColor) {
    change.textColor = color
    indicator.backgroundColor = color
  }
}
