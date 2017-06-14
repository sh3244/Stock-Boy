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
  let symbol = Label(type: .symbol)
  let name = Label()
  let price = Label(type: .usd)
  let change = Label(type: .usdChange)
  let changePercent = Label(type: .percentChange)
  let open = Label(type: .usd, prefix: "Open: ")
  let high = Label(type: .usd, prefix: "High: ")
  let low = Label(type: .usd, prefix: "Low: ")
  let volume = Label(type: .volume, prefix: "Vol: ")
  let average_volume = Label(type: .volume, prefix: "Avg Vol: ")
  let high_52_weeks = Label(type: .usd, prefix: "52 Week High: ")
  let low_52_weeks = Label(type: .usd, prefix: "52 Week Low: ")
  let market_cap = Label(type: .volume, prefix: "Cap: ")
  let chart = ImageView(frame: .zero)

  public static let heightValue: CGFloat = UISettings.rowHeight
  public static let expandedHeightValue: CGFloat = 440.0
  let regularHeight: CGFloat = QuoteCell.heightValue
  let expandedHeight: CGFloat = QuoteCell.expandedHeightValue

  override func willMove(toSuperview newSuperview: UIView?) {
//    price.textAlignment = .right
//    change.textAlignment = .right
//    changePercent.textAlignment = .right
//    name.textAlignment = .left
//    symbol.textAlignment = .left
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, name, price, change, changePercent])

    symbol.width(50)
    price.width(50)
    equalWidths([price, change, changePercent])

    if contentView.bounds.height > UISettings.rowHeight {
      sv([open, high, low, volume, average_volume, high_52_weeks, low_52_weeks, market_cap, chart])
      layout(
        0,
        |-symbol-name-price-change-changePercent-| ~ 30,
        0,
        |-open-high-low-| ~ 30,
        0,
        |-volume-average_volume-market_cap-| ~ 30,
        0,
        |-high_52_weeks-low_52_weeks-| ~ 30,
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
        |-symbol-name-price-change-changePercent-| ~ 30,
        0
      )
    }
  }
}
