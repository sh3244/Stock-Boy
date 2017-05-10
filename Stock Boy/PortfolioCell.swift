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
  var symbol = Label()
  var shares = Label()
  var price = Label()
  var value = Label()
  var change = Label()

  public static let heightValue: CGFloat = 40.0
  public static let expandedHeightValue: CGFloat = 80.0
  let regularHeight: CGFloat = PortfolioCell.heightValue
  let expandedHeight: CGFloat = PortfolioCell.expandedHeightValue

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, shares, price, value, change])
    equalWidths([symbol, shares, price, value, change])
    layout(
      0,
      |-symbol-shares-price-value-change-| ~ 40,
      0
    )
  }
  
}
