//
//  TradeManager.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/30/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import RxSwift
import Whisper

class TradeManager: NSObject {
  var lastOrder: Order?
  let group = DispatchGroup()

  let disposeBag = DisposeBag()

  static let shared: TradeManager = {
    let instance = TradeManager()

    return instance
  }()

  func announce(message: String, thenRun completion:@escaping ((Void) -> Void)) {
    DispatchQueue.main.async {
      let murmur = Murmur(title: message)
      Whisper.show(whistle: murmur, action: .show(1))
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        completion()
      }
    }
  }

  // Cancels the last 500 orders
  func cancelAllOrders() {
    guard let auth = LoginManager.shared.auth else {
      return
    }

    var currentURL = ""

    announce(message: "Trying to Cancel All Orders") { _ in
      DataManager.shared.fetchRobinhoodOrdersWith(auth: auth, completion: { (orders, url) in
        currentURL = url
        for order in orders {
          DataManager.shared.cancelRobinhoodOrderWith(auth: auth, order: order)
        }

        self.announce(message: "Cancelling More Orders", thenRun: { _ in
          self.cancelOrdersWithPages(remaining: 10, url: currentURL)
        })
      })
    }
  }

  func cancelOrdersWithPages(remaining: Int, url: String) {
    guard let auth = LoginManager.shared.auth, remaining != 0 else {
      return
    }

    DataManager.shared.fetchNextRobinhoodOrdersWith(auth: auth, url: url, completion: { (orders, newURL) in
      self.announce(message: "Canceling Orders", thenRun: { _ in
        for order in orders {
          DataManager.shared.cancelRobinhoodOrderWith(auth: auth, order: order)
        }
        self.cancelOrdersWithPages(remaining: remaining - 1, url: newURL)
      })
    })
  }

  func scalpStockWithInstrument(url: String, percentage: String, shares: Int) {
    guard let auth = LoginManager.shared.auth else {
      return
    }

    DataManager.shared.fetchRobinhoodInstrumentWith(url: url) { (instrument) in
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: instrument.symbol, completion: { (quote) in
        DataManager.shared.submitRobinhoodBuyWith(auth: auth, quote: quote, price: String(format: "%.2f", quote.last_trade_price.floatValueLow()).floatValueLow(), shares: shares, completion: { (order) in
          self.lastOrder = order
          self.announce(message: "Scalp Buy Sent...Attempt Scalp For 60s...", thenRun: {
            self.submitSellWhenOrderComplete(order: order, quote: quote, shares: shares, percentage: percentage)
          })
        })
      })
    }
  }

  func submitSellWhenOrderComplete(order: Order, quote: Quote, shares: Int, percentage: String) {
    guard let auth = LoginManager.shared.auth else {
      return
    }
    let counter = Observable<Int>.interval(2.0, scheduler: ConcurrentDispatchQueueScheduler(qos: .utility))

    var sold = false
    DispatchQueue.global(qos: .utility).async {
      let scalp = counter.subscribe({ (event) in
        if sold {
          return
        }
        self.announce(message: "Checking Buy...", thenRun: {
          DataManager.shared.fetchRobinhoodOrderWith(auth: auth, url: order.url, completion: { (order) in
            if order.state == "filled" {
              DataManager.shared.submitRobinhoodSellWith(auth: auth, quote: quote, price: String(format: "%.2f", quote.last_trade_price.floatValueHigh() * percentage.floatValueHigh()).floatValueHigh(), shares: shares, completion: { (order) in
                self.lastOrder = order
                self.announce(message: "Buy Complete, Scalp Sell (" + shares.description + " shares" + ") Subbed...", thenRun: {

                })
                sold = true
                return
              })
            }
            if order.state == "cancelled" {
              return
            }
          })
        })
      })

      Thread.sleep(forTimeInterval: 60)
      scalp.dispose()

      DataManager.shared.fetchRobinhoodOrderWith(auth: auth, url: order.url, completion: { (order) in
        self.announce(message: "Scalp Failed, Cancelling...", thenRun: {
          DataManager.shared.cancelRobinhoodOrderWith(auth: auth, order: order)
        })
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

func getHistoricalPrices(symbol: String, completion:@escaping (([String]) -> Void)) {
  DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: symbol, parameters: Historicals.oneYearParameters()) { (historicals) in
    let object: Historicals? = historicals
    if let objs = object?.historicals {
      var prices: [String] = []
      for historical in objs {
        prices.append(historical.close_price)
      }
      completion(prices)
    }
  }
}
