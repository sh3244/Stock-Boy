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
  var low_52_weeks = Label()
  var market_cap = Label()
  var chart = ImageView(frame: .zero)

  public static let heightValue: CGFloat = 40.0
  public static let expandedHeightValue: CGFloat = 480.0
  let regularHeight: CGFloat = QuoteCell.heightValue
  let expandedHeight: CGFloat = QuoteCell.expandedHeightValue

  override func willMove(toSuperview newSuperview: UIView?) {
    price.textAlignment = .right
    change.textAlignment = .left
    name.textAlignment = .left
    symbol.textAlignment = .right
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, name, price, change])

    change.width(50)
    symbol.width(50)
    price.width(60)
    if contentView.bounds.height > 40.0 {
      sv([open, high, low, volume, average_volume, high_52_weeks, low_52_weeks, market_cap, chart])
      layout(
        0,
        |-symbol-name-price-change-| ~ 40,
        0,
        |-open-high-low-| ~ 40,
        0,
        |-volume-average_volume-market_cap-| ~ 40,
        0,
        |-high_52_weeks-low_52_weeks-| ~ 40,
        0,
        |chart| ~ 320,
        0
      )

      equalWidths([open, high, low, volume, average_volume, market_cap])
      equalWidths([high_52_weeks, low_52_weeks])
    }
    else {
      layout(
        0,
        |-symbol-name-price-change-| ~ 40,
        0
      )
    }
  }

  func apply(color: UIColor) {
    self.change.textColor = color
  }
}
