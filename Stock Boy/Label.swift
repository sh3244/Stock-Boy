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
  case percentChange
  case usdChange
  case percent
  case usd
  case volume
  case symbol
  case regular
  case risk
}

class Label: UILabel {
  var type: LabelType = .regular
  var ctext = ""
  var prefix = ""

  var didChange = false
  var shouldBlink = true

  override init(frame: CGRect) {
    super.init(frame: frame)
    textColor = UISettings.foregroundColor
    textAlignment = .center
    font = UIFont.systemFont(ofSize: UISettings.textSize)
    backgroundColor = .clear
    numberOfLines = 0
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
      case .risk:
        if newValue?.isGreaterThan("0") ?? false {
          textColor = UISettings.badColor
        } else if newValue?.isLessThan("0") ?? false {
          textColor = UISettings.goodColor
        } else {
          textColor = UISettings.neutralColor
        }
        if ctext != newValue?.toUSD() ?? "" {
          ctext = newValue?.toUSD() ?? ""
          blink()
        }
      case .usdChange:
        if newValue?.isGreaterThan("0") ?? false {
          textColor = UISettings.goodColor
        } else if newValue?.isLessThan("0") ?? false {
          textColor = UISettings.badColor
        } else {
          textColor = UISettings.neutralColor
        }
        if ctext != newValue?.toUSD() ?? "" {
          ctext = newValue?.toUSD() ?? ""
          blink()
        }

      case .percentChange:
        if newValue?.isGreaterThan("1.00") ?? false {
          textColor = UISettings.goodColor
        } else if newValue?.isLessThan("1.00") ?? false {
          textColor = UISettings.badColor
        } else {
          textColor = UISettings.neutralColor
        }
        if ctext != newValue?.toPercentChange() ?? "" {
          ctext = newValue?.toPercentChange() ?? ""
          blink()
        }

      case .usd:
        if ctext != newValue?.toUSD() ?? "" {
          ctext = newValue?.toUSD() ?? ""
          blink()
        }
      case .volume:
        if ctext != newValue?.toVolume() ?? "" {
          ctext = newValue?.toVolume() ?? ""
          blink()
        }
      case.symbol:
        if ctext != newValue?.uppercased() ?? "" {
          ctext = newValue?.uppercased() ?? ""
          blink()
        }
      default:
        ctext = newValue ?? ""
      }
      super.text = prefix + ctext
    }
  }

  func blink() {
    if superview != nil && TransitionManager.shared.shouldAnimate && self.shouldBlink {
      let blink = View(color: UISettings.foregroundColor)
      sv(blink)
      blink.alpha = 0.5
      blink.fillContainer()
      blink.layer.cornerRadius = 5
      blink.clipsToBounds = true
      bringSubview(toFront: blink)

      UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
        blink.alpha = 0
      }, completion: { success in
        blink.removeFromSuperview()
      })
    }
  }

}
