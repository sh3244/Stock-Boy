//
//  TradeViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/30/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class TradeViewController: ViewController, SelectionViewDelegate {
  let selectionView = SelectionView(["Scalp 2%", "Scalp 5%"])
  let statusView = StatusView("", .gray)
  let searchBar = SearchBar()

  var quote: Quote?

  convenience init(_ title: String, symbol: String) {
    self.init(title)
    DataManager.shared.fetchRobinhoodQuoteWith(symbol: symbol) { (quote) in
      self.quote = quote
      self.statusView.title.text = quote.symbol
      self.searchBar.text = quote.symbol
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar.delegate = self
    searchBlock = { string in
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: string) { (quote) in
        self.quote = quote
        self.statusView.title.text = quote.symbol
        self.searchBar.text = quote.symbol
      }
    }

    selectionView.delegate = self
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

  func selected(title: String) {
    switch title {
    case "Scalp 2%":
      break
    default:
      break
    }
  }

}
