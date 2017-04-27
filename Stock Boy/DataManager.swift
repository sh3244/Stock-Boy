//
//  DataManager.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Argo
import Alamofire
import RxSwift

public let baseURL = "https://api.robinhood.com/"

//https://github.com/sanko/Robinhood

class DataManager: NSObject {

  let orders: Variable<[Orders]> = Variable([])

  static let shared: DataManager = {
    let instance = DataManager()

    return instance
  }()

  // MARK: Auth

  func fetchRobinhoodAuthWith(username: String, password: String, completion:@escaping ((Auth) -> Void)) {
    let parameters: Parameters = ["username": username,
                                  "password": password
    ]

    Alamofire.request(baseURL + "api-token-auth/", method: .post, parameters: parameters).responseJSON { response in
      if let json = response.result.value {
        let object: Auth? = decode(json)
        if let obj = object {
          completion(obj)
        }
      }
    }
  }

  // MARK: Account

  func fetchRobinhoodAccountWith(auth: Auth, completion:@escaping ((Account) -> Void)) {
    let headers = ["authorization": "token " + auth.token]

    Alamofire.request(baseURL + "accounts/", method: .get, headers: headers).responseJSON { response in
      if let json = response.result.value {
        let object: Accounts? = decode(json)
        if let obj = object?.results.first {
          completion(obj)
        }
      }
    }
  }

  // MARK: Portfolio

  func fetchRobinhoodPortfolioWith(auth: Auth, completion:@escaping ((Portfolio) -> Void)) {
    let headers = ["authorization": "token " + auth.token]

    Alamofire.request(baseURL + "portfolios/", method: .get, headers: headers).responseJSON { response in
      if let json = response.result.value {
        let object: Portfolios? = decode(json)
        if let obj = object?.results.first {
          completion(obj)
        }
      }
    }
  }

  // MARK: Position

  func fetchRobinhoodPositionsWith(auth: Auth, completion:@escaping (([Position]) -> Void)) {
    let headers = ["authorization": "token " + auth.token]

    Alamofire.request(baseURL + "positions/", method: .get, headers: headers).responseJSON { response in
      if let json = response.result.value {
        let object: Positions? = decode(json)
        if let positions: [Position] = object?.results {
          let filtered = positions.filter { position in
            if let quantity = Double(position.quantity) {
              if quantity > 0 {
                return true
              }
            }
            return false
          }
          completion(filtered)
        }
      }
    }
  }

  // MARK: Quote

  func fetchRobinhoodQuoteWith(symbol: String, completion:@escaping ((Quote) -> Void)) {
    let subURL = "quotes/" + symbol + "/"

    Alamofire.request(baseURL + subURL, method: .get).responseJSON { response in
      if let json = response.result.value {
        let object: Quote? = decode(json)
        if let obj = object {
          completion(obj)
        }
      }
    }
  }

  func fetchRobinhoodQuoteWith(url: String, completion:@escaping ((Quote) -> Void)) {
    Alamofire.request(url, method: .get).responseJSON { response in
      if response.result.value != nil {
        if let json = response.result.value {
          let object: Quote? = decode(json)
          if let obj = object {
            completion(obj)
          }
        }
      }
    }
  }

  func fetchRobinhoodQuotesWith(instruments: [Instrument], completion:@escaping (([Quote]) -> Void)) {
    var url = "https://api.robinhood.com/quotes/?symbols="
    for i in 0..<instruments.count {
      if i > 0 {
        url = url + ","
      }
      url = url + instruments[i].symbol
    }
    Alamofire.request(url, method: .get).responseJSON { response in
      if response.result.value != nil {
        if let json = response.result.value {
          let objects: Quotes? = decode(json)
          if let results = objects?.results {
            completion(results)
          }
        }
      }
    }
  }

  // MARK: Instruments

  func fetchRobinhoodInstruments(completion:@escaping (([Instrument]) -> Void)) {
    let subURL = "instruments/"
    Alamofire.request(baseURL + subURL, method: .get).responseJSON { response in
      if let json = response.result.value {
        let object: Instruments? = decode(json)
        if let obj = object {
          completion(obj.results)
        }
      }
    }
  }

  func fetchRobinhoodInstrumentWith(url: String, completion:@escaping ((Instrument) -> Void)) {
    Alamofire.request(url, method: .get).responseJSON { response in
      if let json = response.result.value {
        let object: Instrument? = decode(json)
        if let obj = object {
          completion(obj)
        }
      }
    }
  }

  func fetchRobinhoodInstrumentsWith(watchlist: [WatchlistItem], completion:@escaping (([Instrument]) -> Void)) {
    var instruments: [Instrument] = []
    watchlist.forEach { (item) in
      fetchRobinhoodInstrumentWith(url: item.instrument, completion: { (instrument) in
        instruments.append(instrument)
        if instruments.count == watchlist.count {
          completion(instruments)
        }
      })
    }
  }

  // MARK: Fundamentals

  func fetchRobinhoodFundamentalsWith(symbol: String, completion:@escaping ((Fundamentals) -> Void)) {
    let subURL = "fundamentals/" + symbol + "/"

    Alamofire.request(baseURL + subURL, method: .get).responseJSON { response in
      if let json = response.result.value {
        let object: Fundamentals? = decode(json)
        if let obj = object {
          completion(obj)
        }
      }
    }
  }

  // MARK: Watchlist

  func fetchRobinhoodDefaultWatchlistWith(auth: Auth, completion:@escaping ((Watchlist) -> Void)) {
    let subURL = "watchlists/Default/"

    let headers = ["authorization": "token " + auth.token]

    Alamofire.request(baseURL + subURL, method: .get, headers:headers).responseJSON { response in
      if let json = response.result.value {
        let object: Watchlist? = decode(json)
        if let obj = object {
          completion(obj)
        }
      }
    }
  }

  // MARK: Historicals

  func fetchRobinhoodHistoricalsWith(symbol: String, parameters: Parameters, completion:@escaping ((Historicals) -> Void)) {
    let subURL = "quotes/historicals/" + symbol.uppercased() + "/"

    Alamofire.request(baseURL + subURL, method: .get, parameters: parameters).responseJSON { response in
      if let json = response.result.value {
        let object: Historicals? = decode(json)
        if let obj = object {
          completion(obj)
        }
      }
    }
  }

  // MARK: Orders

  func submitRobinhoodOrderWith(auth: Auth, request: OrderRequest, completion:@escaping ((Order) -> Void)) {
    let subURL = "orders/"
    let headers = ["authorization": "token " + auth.token]

    Alamofire.request(baseURL + subURL, method: .post, parameters: request.parameters(), headers: headers).responseJSON { response in
      if let json = response.result.value {
        let object: Order? = decode(json)
        if let obj = object {
          completion(obj)
        }
      }
    }
  }

  func submitRobinhoodBuyWith(auth: Auth, quote: Quote, price: Float, completion:@escaping ((Order) -> Void)) {
    DataManager.shared.fetchRobinhoodAccountWith(auth: auth) { (account) in
      let request = OrderRequest(account: account.url, instrument: quote.instrument, symbol: quote.symbol, price: price, quantity: 1, type: .limit, time_in_force: .gtc, trigger: .immediate, side: .buy)
      DataManager.shared.submitRobinhoodOrderWith(auth: auth, request: request, completion: { (order) in
        completion(order)
      })
    }
  }

  func submitRobinhoodSellWith(auth: Auth, quote: Quote, price: Float, completion:@escaping ((Order) -> Void)) {
    DataManager.shared.fetchRobinhoodAccountWith(auth: auth) { (account) in
      let request = OrderRequest(account: account.url, instrument: quote.instrument, symbol: quote.symbol, price: price, quantity: 1, type: .limit, time_in_force: .gtc, trigger: .immediate, side: .sell)
      DataManager.shared.submitRobinhoodOrderWith(auth: auth, request: request, completion: { (order) in
        completion(order)
      })
    }
  }

  func fetchRobinhoodOrdersWith(auth: Auth) {
    let subURL = "orders/"
    let headers = ["authorization": "token " + auth.token]

    Alamofire.request(baseURL + subURL, method: .get, headers: headers).responseJSON { response in
      if let json = response.result.value {
        let object: Orders? = decode(json)
        if let obj = object {
          self.orders.value.append(obj)
        }
      }
    }
  }

  func fetchRobinhoodOrdersWith(auth: Auth, completion:@escaping (([Order]) -> Void)) {
    let subURL = "orders/"
    let headers = ["authorization": "token " + auth.token]

    Alamofire.request(baseURL + subURL, method: .get, headers: headers).responseJSON { response in
      if let json = response.result.value {
        let object: Orders? = decode(json)
        if let obj = object {
          completion(obj.results)
        }
      }
    }
  }

  func cancelAllRobinhoodOrdersWith(auth: Auth) {
    fetchRobinhoodOrdersWith(auth: auth) { orders in
      for order in orders {
        self.cancelRobinhoodOrderWith(auth: auth, order: order)
      }
    }
  }

  func cancelRobinhoodOrderWith(auth: Auth, order: Order) {
    let headers = ["authorization": "token " + auth.token]
    guard let cancel = order.cancel else {
      return
    }
    Alamofire.request(cancel, method: .post, headers: headers).responseJSON { response in

    }
  }

}
