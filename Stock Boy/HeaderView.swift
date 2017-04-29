//
//  HeaderView.swift
//  Stock Boy
//
//  Created by Sam on 4/27/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Foundation
import Stevia

class HeaderView: View {
  var labels: [Label] = []
  let lining = View(color: UISettings.foregroundColor)

  convenience init(_ choices: [String]) {
    self.init(frame: .zero)
    for choice in choices {
      let label = Label(choice)
      labels.append(label)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    sv(labels)
    sv(lining)
    equalWidths(labels)
    equalHeights(labels)
    alignTops(labels)
    var previousLabel: Label? = nil

    lining.height(2)
    lining.fillHorizontally()
    lining.bottom(0)

    for label in labels {
      if let prev = previousLabel {
        if label != labels.last ?? label {
          prev-label
        }
        else {
          layout(
            0,
            prev-label-| ~ 40,
            0
          )
        }
      }
      else {
        |-label
      }
      previousLabel = label
    }
  }
}
