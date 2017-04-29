//
//  Label.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

enum LabelType {
  case title
  case percent
  case usd
  case volume
  case symbol
  case regular
}

class Label: UILabel {
  var type: LabelType = .regular
  var ctext = ""
  var prefix = ""

  var didChange = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    textColor = UISettings.foregroundColor
    textAlignment = .center
    font = UIFont.systemFont(ofSize: 14)
    backgroundColor = .clear
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  convenience init(_ title: String) {
    self.init(frame: .zero)
    super.text = title
  }

  convenience init(_ title: String = "", type: LabelType = .regular, prefix: String = "") {
    self.init(frame: .zero)
    super.text = prefix + title
    self.prefix = prefix
    self.type = type
    switch type {
    case .title:
      font = UIFont.systemFont(ofSize: 24)
    default:
      break
    }
  }

  override var text: String? {
    get {
      return ctext
    }
    set {
      switch type {
      case .percent:
        if newValue?.isGreaterThan("1.00") ?? false {
          textColor = .green
        } else if newValue?.isLessThan("1.00") ?? false {
          textColor = .red
        }

        if ctext != newValue?.toPercentChange() ?? "" {
          ctext = newValue?.toPercentChange() ?? ""
          blink()
        }

      case .usd:
        if ctext != newValue?.toUSD() ?? "" {
          ctext = newValue?.toUSD() ?? ""
        }
      case .volume:
        if ctext != newValue?.toVolume() ?? "" {
          ctext = newValue?.toVolume() ?? ""
        }
      case.symbol:
        ctext = newValue?.uppercased() ?? ""
      default:
        ctext = newValue ?? ""
      }
      super.text = prefix + ctext
    }
  }

  func blink() {
    if superview != nil && TransitionManager.shared.shouldAnimate {
      let blink = View(color: UISettings.foregroundColor)
      sv(blink)
      blink.fillContainer()
      bringSubview(toFront: blink)

      UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
        blink.alpha = 0
      }, completion: { success in
        blink.removeFromSuperview()
      })
    }
  }

}
