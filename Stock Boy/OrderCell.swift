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
  var symbol = Label(type: .symbol)
  var type = Label(type: .symbol)
  var quantity = Label(type: .volume)
  var price = Label(type: .usd)
  var cost = Label(type: .usd)

  public static let heightValue: CGFloat = 40.0
  public static let expandedHeightValue: CGFloat = 80.0
  let regularHeight: CGFloat = OrderCell.heightValue
  let expandedHeight: CGFloat = OrderCell.expandedHeightValue

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, type, quantity, price, cost])
    equalWidths([symbol, type, quantity, price, cost])

    layout(
      0,
      |-symbol-type-quantity-price-cost-| ~ 40,
      0
    )
  }
}
