//
//  TradeViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/30/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class TradeViewController: ViewController {
  let selectionView = SelectionView(["Scalp 2%", "Scalp 5%"])
  let statusView = StatusView("", .gray)

  var quote: Quote?

  convenience init(_ title: String, symbol: String) {
    self.init(title)
    DataManager.shared.fetchRobinhoodQuoteWith(symbol: symbol) { (quote) in
      self.quote = quote
      self.statusView.title.text = quote.symbol
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([selectionView, statusView])
    view.layout(
      0,
      |statusView|,
      8,
      |selectionView|
    )
  }

}
