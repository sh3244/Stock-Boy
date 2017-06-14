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
  var widths: [CGFloat] = []

  convenience init(_ choices: [String], _ widths: [CGFloat] = []) {
    self.init(frame: .zero)
    for choice in choices {
      let label = Label(choice)
      labels.append(label)
    }
    self.widths = widths
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    sv(labels)
    sv(lining)
    equalHeights(labels)
    alignTops(labels)
//    equalWidths(labels)

    var previousLabel: Label? = nil

    lining.height(1.5)
    lining.fillHorizontally()
    lining.bottom(0)

    if widths.isEmpty {
      equalWidths(self.labels)
    }

    var index = 0
    for label in labels {
      if !widths.isEmpty {
        if widths[index] < 0 {
          label.width(>=(-widths[index]))
        }
        else {
          label.width(widths[index])
        }
      }
      if let prev = previousLabel {
        if label != labels.last ?? label {
          prev-label
        }
        else {
          layout(
            0,
            prev-label-| ~ 30,
            0
          )
        }
      }
      else {
        |-label
      }
      previousLabel = label
      index += 1
    }
  }
}
