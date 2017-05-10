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
  var symbol = Label(type: .symbol)
  var name = Label()
  var price = Label(type: .usd)
  var change = Label(type: .usdChange)
  var changePercent = Label(type: .percentChange)
  var open = Label(type: .usd, prefix: "Open: ")
  var high = Label(type: .usd, prefix: "High: ")
  var low = Label(type: .usd, prefix: "Low: ")
  var volume = Label(type: .volume, prefix: "Vol: ")
  var average_volume = Label(type: .volume, prefix: "Avg Vol: ")
  var high_52_weeks = Label(type: .usd, prefix: "52 Week High: ")
  var low_52_weeks = Label(type: .usd, prefix: "52 Week Low: ")
  var market_cap = Label(type: .volume, prefix: "Cap: ")
  var chart = ImageView(frame: .zero)

  public static let heightValue: CGFloat = 40.0
  public static let expandedHeightValue: CGFloat = 480.0
  let regularHeight: CGFloat = QuoteCell.heightValue
  let expandedHeight: CGFloat = QuoteCell.expandedHeightValue

  override func willMove(toSuperview newSuperview: UIView?) {
    price.textAlignment = .right
    change.textAlignment = .right
    changePercent.textAlignment = .right
    name.textAlignment = .left
    symbol.textAlignment = .left
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, name, price, change, changePercent])
    equalWidths([price, change, changePercent])

    change.width(50)
    symbol.width(50)
    price.width(60)
    changePercent.width(50)
    if contentView.bounds.height > 40.0 {
      sv([open, high, low, volume, average_volume, high_52_weeks, low_52_weeks, market_cap, chart])
      layout(
        0,
        |-symbol-name-price-change-changePercent-| ~ 40,
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
        |-symbol-name-price-change-changePercent-| ~ 40,
        0
      )
    }
  }
}
