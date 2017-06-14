//
//  OrderCell.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class OrderCell: TableViewCell {
  let symbol = Label(type: .symbol)
  let type = Label(type: .symbol)
  let quantity = Label(type: .volume)
  let price = Label(type: .usd)
  let cost = Label(type: .usd)
  let status = Label(type: .symbol)

  public static let heightValue: CGFloat = UISettings.rowHeight
  public static let expandedHeightValue: CGFloat = 80.0
  let regularHeight: CGFloat = OrderCell.heightValue
  let expandedHeight: CGFloat = OrderCell.expandedHeightValue

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, type, quantity, price, cost, status])
    symbol.width(50)
    equalWidths([symbol, type, quantity, price, cost])

    layout(
      0,
      |-symbol-type-quantity-price-cost-status| ~ 30,
      0
    )
  }
}
