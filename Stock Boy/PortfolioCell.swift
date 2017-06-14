//
//  PortfolioCell.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class PortfolioCell: TableViewCell {
  let symbol = Label()
  let shares = Label()
  let price = Label()
  let value = Label()
  let cost = Label()
  let performance = Label()

  public static let heightValue: CGFloat = UISettings.rowHeight
  public static let expandedHeightValue: CGFloat = 80.0
  let regularHeight: CGFloat = PortfolioCell.heightValue
  let expandedHeight: CGFloat = PortfolioCell.expandedHeightValue

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, shares, price, value, cost, performance])
    symbol.width(60)
    equalWidths([symbol, shares, price, value, cost])
    layout(
      0,
      |-symbol-shares-price-value-cost-performance-| ~ 30,
      0
    )
  }
  
}
