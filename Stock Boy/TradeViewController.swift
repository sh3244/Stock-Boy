//
//  TradeViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/30/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia
import RxSwift

class TradeViewController: ViewController, SelectionViewDelegate {
  let selectionView = SelectionView(["Scalp 2%", "Scalp 5%", "Custom", "Cancel All"])
  let statusView = StatusView("", .gray)
  let searchBar = SearchBar()
  let custom = Label("Custom Parameters", type: .title)
  let percent = TextField("1.06")
  let shares = TextField("1")

  let price = Label("", type: .title)

  var quote: Quote?

  let disposeBag = DisposeBag()

  convenience init(_ title: String, symbol: String) {
    self.init(title)
    DataManager.shared.fetchRobinhoodQuoteWith(symbol: symbol) { (quote) in
      self.quote = quote
      self.update()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    percent.delegate = self
    shares.delegate = self

    searchBar.delegate = self
    searchBlock = { string in
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: string) { (quote) in
        self.quote = quote
        self.update()
      }
    }

    selectionView.delegate = self

    let counter = myInterval(2)
    _ = counter
      .subscribe(onNext: { (value) in
        if let quo = self.quote {
          DataManager.shared.fetchRobinhoodQuoteWith(symbol: quo.symbol, completion: { (quote) in
            self.quote = quote
            self.update()
          })
        }
      })
    .addDisposableTo(disposeBag)
  }

  func update() {
    if let quo = quote {
      self.statusView.title.text = quo.symbol
      self.price.text = quo.last_trade_price
      self.searchBar.text = quo.symbol
    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([selectionView, statusView, custom, percent, shares, price])
    view.layout(
      0,
      |searchBar|,
      |statusView| ~ 40,
      8,
      |price| ~ 40,
      8,
      |selectionView|,
      8,
      |custom| ~ 40,
      8,
      |percent| ~ 40,
      8,
      |shares| ~ 40
    )
  }

  func selected(title: String) {
    switch title {
    case "Scalp 2%":
      if let quo = quote {
        TradeManager.shared.scalpStockWithInstrument(url: quo.instrument, percentage: "1.02", shares: 1)
      }
    case "Scalp 5%":
      if let quo = quote {
        TradeManager.shared.scalpStockWithInstrument(url: quo.instrument, percentage: "1.05", shares: 1)
      }
    case "Custom":
      if let quo = quote, let percentage = percent.text, let quantity = shares.text?.intValue() {
        TradeManager.shared.scalpStockWithInstrument(url: quo.instrument, percentage: percentage, shares: quantity)
      }
    case "Cancel All":
      if let auth = LoginManager.shared.auth {
        DataManager.shared.cancelAllRobinhoodOrdersWith(auth: auth)
      }
    default:
      break
    }
  }

}
