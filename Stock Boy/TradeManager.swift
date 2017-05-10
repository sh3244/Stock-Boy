//
//  TradeManager.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/30/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import RxSwift

class TradeManager: NSObject {
  var lastOrder: Order?

  let disposeBag = DisposeBag()

  static let shared: TradeManager = {
    let instance = TradeManager()

    return instance
  }()

  func scalpStockWithInstrument(url: String, percentage: String, shares: Int) {
    guard let auth = LoginManager.shared.auth else {
      return
    }

    DataManager.shared.fetchRobinhoodInstrumentWith(url: url) { (instrument) in
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: instrument.symbol, completion: { (quote) in
        DataManager.shared.submitRobinhoodBuyWith(auth: auth, quote: quote, price: String(format: "%.2f", quote.last_trade_price.floatValueLow()).floatValueLow(), shares: shares, completion: { (order) in
          self.lastOrder = order
          print("Scalp Buy Sent")
          self.submitSellWhenOrderComplete(order: order, quote: quote, shares: shares, percentage: percentage)
        })
      })
    }
  }

  func submitSellWhenOrderComplete(order: Order, quote: Quote, shares: Int, percentage: String) {
    guard let auth = LoginManager.shared.auth else {
      return
    }

    DispatchQueue.global().async {
      print("Scalping...")

      let counter = Observable<Int>.interval(3.0, scheduler: SerialDispatchQueueScheduler(qos: .utility))
      let _ = counter.subscribe({ (event) in
        DataManager.shared.fetchRobinhoodOrderWith(auth: auth, url: order.url, completion: { (order) in
          print("Checking Scalp Buy...", (order.average_price?.floatValueLow() ?? 0.0), quote.last_trade_price.floatValueHigh() * percentage.floatValueHigh())
          DataManager.shared.submitRobinhoodSellWith(auth: auth, quote: quote, price: String(format: "%.2f", quote.last_trade_price.floatValueHigh() * percentage.floatValueHigh()).floatValueHigh(), shares: shares, completion: { (order) in
            self.lastOrder = order
            print("Scalp Submitted", quote.last_trade_price.floatValueHigh() * percentage.floatValueHigh())
          })
        })
      })

      Thread.sleep(forTimeInterval: 30)

      DataManager.shared.fetchRobinhoodOrderWith(auth: auth, url: order.url, completion: { (order) in
        DataManager.shared.cancelRobinhoodOrderWith(auth: auth, order: order)
        print("Scalp Canceled")
      })
    }
  }
}

struct Strategy {
  var finished = false
  var stage = 0
  var target = 0
  
  mutating func runStage() {
    stage += 1
  }
}
