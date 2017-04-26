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
  var symbol = Label()
  var type = Label()
  var quantity = Label()
  var price = Label()
  var cost = Label()

  public static let heightValue: CGFloat = 40.0
  public static let expandedHeightValue: CGFloat = 500.0
  let regularHeight: CGFloat = OrderCell.heightValue
  let expandedHeight: CGFloat = OrderCell.expandedHeightValue

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .black
    symbol.text = "ABCD"
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, type, quantity, price, cost])

    symbol.width(55)
    type.width(50)
    quantity.width(100)
    price.width(70)

    if contentView.bounds.height > 40.0 {
      layout(
        0,
        |-symbol-type-quantity-price-cost-| ~ 40,
        0
      )
    }
    else {
      layout(
        0,
        |-symbol-type-quantity-price-cost-| ~ 40,
        0
      )
    }
  }
}
