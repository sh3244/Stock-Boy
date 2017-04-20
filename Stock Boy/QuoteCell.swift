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
  var button = Button()
  var symbol = Label()
  var price = Label()

  public static let heightValue: CGFloat = 80.0
  let height: CGFloat = 80.0

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    price.text = "$$$"

    contentView.backgroundColor = .black
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    sv([symbol, price])
    equalWidths([symbol, price])
    equalHeights([symbol, price])
    layout(
      0,
      |-symbol-|,
      |-price ~ 40,
      0
    )
  }

}
