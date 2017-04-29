//
//  TableView.swift
//  Stock Boy
//
//  Created by Sam on 4/28/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class TableView: UITableView {

  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    backgroundColor = UISettings.backgroundColor
    separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
    tintColor = UISettings.foregroundColor
    separatorColor = UISettings.neutralColor
    alpha = 0
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
