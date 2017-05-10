//
//  TableViewCell.swift
//  Stock Boy
//
//  Created by Sam on 4/22/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UISettings.backgroundColor
    selectionStyle = .none
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func resetSubviews() {
    for view in contentView.subviews {
      if let label = view as? Label {
        label.text = ""
      }
      if let image = view as? ImageView {
        image.image = nil
      }
    }
  }
}
