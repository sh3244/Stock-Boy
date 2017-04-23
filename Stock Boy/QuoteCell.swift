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
  var name = Label()
  var price = Label()
  var change = Label()

  

  public static let heightValue: CGFloat = 40.0
  public static let expandedHeightValue: CGFloat = 240.0
  let regularHeight: CGFloat = QuoteCell.heightValue
  let expandedHeight: CGFloat = QuoteCell.expandedHeightValue

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    price.text = "$$$"

    backgroundColor = .black
    sv([symbol, name, price, change])
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    change.width(70)
    symbol.width(60)
    price.width(70)
    if contentView.bounds.height > 40.0 {
      layout(
        0,
fdsa,
        0
      )
    }
    else {
      layout(
        0,
        |-symbol-name-price-change-|,
        0
      )
    }
  }

  override func prepareForReuse() {
    subviews.forEach { (view) in
      view.removeFromSuperview()
    }
  }

  func apply(color: UIColor) {
    change.textColor = color
  }
}
