//
//  SelectionView.swift
//  Stock Boy
//
//  Created by Sam on 4/27/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Foundation
import Stevia

protocol SelectionViewDelegate {
  func selected(title: String)
}

class SelectionView: View {
  var buttons: [Button] = []

  var delegate: SelectionViewDelegate?

  convenience init(_ choices: [String]) {
    self.init(frame: .zero)
    for choice in choices {
      let button = Button(choice)
      button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
      buttons.append(button)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    sv(buttons)
    equalWidths(buttons)
    equalHeights(buttons)
    alignTops(buttons)
    var previousButton: Button? = nil

    for button in buttons {
      if let prev = previousButton {
        if button != buttons.last ?? button {
          prev-button
        }
        else {
          layout(
          0,
          prev-button-| ~ 30,
          0
          )
        }
      }
      else {
        |-button
      }
      previousButton = button
    }
  }

  func buttonPressed(sender: UIButton) {
    buttons.forEach { (button) in
      button.isSelected = false
    }
    sender.isSelected = true
    if let title = sender.titleLabel?.text {
      delegate?.selected(title: title)
    }
  }

}
