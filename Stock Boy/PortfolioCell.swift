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
  var value = Label()
  var change = Label()

  public static let heightValue: CGFloat = 40.0
  public static let expandedHeightValue: CGFloat = 500.0
  let regularHeight: CGFloat = PortfolioCell.heightValue
  let expandedHeight: CGFloat = PortfolioCell.expandedHeightValue

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .black

  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.subviews.forEach { (view) in
      view.removeFromSuperview()
    }
    sv([symbol, value, change])

    change.width(70)
    symbol.width(55)
    layout(
      0,
      |-symbol-value-change-| ~ 40,
      0
    )
  }
  
}
