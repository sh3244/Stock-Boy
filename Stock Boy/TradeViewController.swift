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
  let selectionView = SelectionView(["Scalp 2%", "Scalp 5%", "Scalp Custom"])
  let otherSelectionView = SelectionView(["Buy", "Sell", "Cancel All"])
  let statusView = StatusView("", .gray)
  let searchBar = SearchBar()
  let percent = TextField(placeholder: "Target Percentage (1.06)")
  let shares = TextField(placeholder: "Shares (100)")
  let targetPrice = TextField(placeholder: "Price (1.01)")
  let price = Label("", type: .title, prefix: "Current Price: ")

  // risk, targetMax, targetMin, volatility, averages, derivatives
  let risk = Label(type: .risk, prefix: "Risk: ")
  let targetMax = Label(type: .usd, prefix: "High Ball: ")
  let targetMin = Label(type: .usd, prefix: "Low Ball: ")
  let volatility = Label(type: .regular, prefix: "Volatility: ")
  let averages = Label(type: .regular, prefix: "Averages: ")
  let derivatives = Label(type: .regular, prefix: "Derivatives: ")
  let volumes = Label(type: .regular, prefix: "Volumes: ")
  let gain = Label(type: .percentChange, prefix: "Gain: ")
  let loss = Label(type: .percentChange, prefix: "Loss: ")

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
    targetPrice.delegate = self
    percent.text = "1.04"
    shares.text = "1"

    searchBar.delegate = self
    searchBlock = { string in
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: string) { (quote) in
        self.quote = quote
        self.update()
      }
    }

    selectionView.delegate = self
    otherSelectionView.delegate = self

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
      self.targetPrice.text = quo.last_trade_price

      DecisionManager.shared.generateProposalFor(symbol: quo.symbol, completion: { (proposal) in
        self.risk.text = proposal.risk.description
        self.targetMin.text = proposal.targetMin.description
        self.targetMax.text = proposal.targetMax.description
        self.volatility.text = proposal.volatility.description
        
        self.averages.text = proposal.averagesArray.description
        self.derivatives.text = proposal.derivatives.description
        self.volumes.text = proposal.volumesArray.description
        self.gain.text = proposal.gain.description
        self.loss.text = proposal.loss.description
      })
    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([searchBar, selectionView, statusView, percent, shares, price, targetPrice, otherSelectionView])
    view.sv([risk, targetMax, targetMin, volatility, averages, derivatives, volumes, gain, loss])
    equalSizes([risk, targetMax, targetMin, volatility, gain, loss])
    view.layout(
      0,
      |searchBar|,
      |statusView| ~ 40,
      8,
      |price| ~ 40,
      8,
      |selectionView|,
      8,
      |percent| ~ 40,
      8,
      |shares| ~ 40,
      8,
      |targetPrice| ~ 40,
      8,
      |otherSelectionView|,
      8,
      |targetMax-targetMin-risk|,
      8,
      |gain-loss-volatility|,
      8,
      |averages|,
      8,
      |derivatives|,
      8,
      |volumes|
    )
  }

  func selected(title: String) {
    switch title {
    case "Scalp 2%":
      if let quo = quote, let quantity = shares.text?.intValue() {
        TradeManager.shared.scalpStockWithInstrument(url: quo.instrument, percentage: "1.02", shares: quantity)
      }
    case "Scalp 5%":
      if let quo = quote, let quantity = shares.text?.intValue() {
        TradeManager.shared.scalpStockWithInstrument(url: quo.instrument, percentage: "1.05", shares: quantity)
      }
    case "Scalp Custom":
      if let quo = quote, let percentage = percent.text, let quantity = shares.text?.intValue() {
        TradeManager.shared.scalpStockWithInstrument(url: quo.instrument, percentage: percentage, shares: quantity)
      }
    case "Buy":
      if let auth = LoginManager.shared.auth, let quo = quote, let aPrice = targetPrice.text?.floatValueLow(), let quantity = shares.text?.intValue() {
        DataManager.shared.submitRobinhoodBuyWith(auth: auth, quote: quo, price: aPrice, shares: quantity, completion: { (order) in

        })
      }
    case "Sell":
      if let auth = LoginManager.shared.auth, let quo = quote, let aPrice = targetPrice.text?.floatValueHigh(), let quantity = shares.text?.intValue() {
        DataManager.shared.submitRobinhoodSellWith(auth: auth, quote: quo, price: aPrice, shares: quantity, completion: { (order) in

        })
      }
    case "Cancel All":
      TradeManager.shared.cancelAllOrders()
    default:
      break
    }
  }

}
