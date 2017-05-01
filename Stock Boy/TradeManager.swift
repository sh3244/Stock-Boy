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
        DataManager.shared.submitRobinhoodBuyWith(auth: auth, quote: quote, price: quote.last_trade_price.floatValueLow(), shares: shares, completion: { (order) in
          self.lastOrder = order
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
      let counter = Observable<Int>.interval(5.0, scheduler: MainScheduler())
        .subscribe {
          DataManager.shared.fetchRobinhoodOrderWith(auth: auth, url: order.url, completion: { (order) in
            if (order.average_price?.floatValueLow() ?? 0.0) > 0.0 {
              DataManager.shared.submitRobinhoodSellWith(auth: auth, quote: quote, price: quote.last_trade_price.floatValueHigh() * percentage.floatValueHigh(), shares: shares, completion: { (order) in
                self.lastOrder = order
                return
              })
            }
          })
      }

      Thread.sleep(forTimeInterval: 60.0)
      counter.dispose()

      DataManager.shared.fetchRobinhoodOrderWith(auth: auth, url: order.url, completion: { (order) in
        DataManager.shared.cancelRobinhoodOrderWith(auth: auth, order: order)
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
