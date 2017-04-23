//
//  QuoteCell.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class QuoteCell: TableViewCell {
  var symbol = Label()
  var name = Label()
  var price = Label()
  var change = Label()

  var open = Label()
  var high = Label()
  var low = Label()
  var volume = Label()
  var average_volume = Label()
  var high_52_weeks = Label()
//  var dividend_yield = Label()
  var low_52_weeks = Label()
  var market_cap = Label()
//  var pe_ratio = Label()
//  var description = Label()
//  var instrument = Label()

  public static let heightValue: CGFloat = 40.0
  public static let expandedHeightValue: CGFloat = 200.0
  let regularHeight: CGFloat = QuoteCell.heightValue
  let expandedHeight: CGFloat = QuoteCell.expandedHeightValue

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .black

    sv([symbol, name, price, change, open, high, low, volume, average_volume, high_52_weeks, low_52_weeks, market_cap])
    price.textAlignment = .right
    change.textAlignment = .right
    name.textAlignment = .left
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    change.width(70)
    symbol.width(55)
    price.width(70)
    equalWidths([open, high, low])
    equalWidths([volume, average_volume, high_52_weeks, low_52_weeks])
    contentView.subviews.forEach { (view) in
      view.isHidden = true
    }
    if contentView.bounds.height > 40.0 {
      layout(
        0,
        |-symbol-name-price-change-| ~ 40,
        0,
        |-open-high-low-| ~ 40,
        0,
        |-volume-average_volume-| ~ 40,
        0,
        |-high_52_weeks-low_52_weeks-| ~ 40,
        0,
        |-market_cap-| ~ 40,
        0
      )
      contentView.subviews.forEach { (view) in
        view.isHidden = false
      }
    }
    else {
      layout(
        0,
        |-symbol-name-price-change-| ~ 40,
        0
      )
      symbol.isHidden = false
      name.isHidden = false
      price.isHidden = false
      change.isHidden = false
    }
  }

  func apply(color: UIColor) {
    change.textColor = color
  }
}
