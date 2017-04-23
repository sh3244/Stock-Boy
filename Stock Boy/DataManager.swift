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

public let baseURL = "https://api.robinhood.com/"

class DataManager: NSObject {

  static let shared: DataManager = {
    let instance = DataManager()

    return instance
  }()

  func fetchRobinhoodAuthWith(completion:@escaping ((Auth) -> Void)) {
    let parameters: Parameters = ["username": "sh3244",
                                  "password": "5ezypqj9omp"
    ]

    Alamofire.request(baseURL + "api-token-auth/", method: .post, parameters: parameters).responseJSON { response in
      if let json = response.result.value {
        let auth: Auth = decode(json)!
        completion(auth)
      }
    }
  }

  func fetchRobinhoodQuoteWith(symbol: String, completion:@escaping ((Quote) -> Void)) {
    let subURL = "quotes/" + symbol + "/"

    Alamofire.request(baseURL + subURL, method: .get).responseJSON { response in
      if let json = response.result.value {
        let object: Quote = decode(json)!
        completion(object)
      }
    }
  }

  func fetchRobinhoodQuoteWith(url: String, completion:@escaping ((Quote) -> Void)) {
    Alamofire.request(url, method: .get).responseJSON { response in
      if response.result.value != nil {
        if let json = response.result.value {
          let object: Quote = decode(json)!
          completion(object)
        }
      }
    }
  }

  func fetchRobinhoodQuotesWith(instruments: [Instrument], completion:@escaping (([Quote]) -> Void)) {
    var quotes: [Quote] = []
    for i in 0..<instruments.count {
      DispatchQueue.global().sync {
        self.fetchRobinhoodQuoteWith(url: instruments[i].quote) { quote in
          quotes.append(quote)
          if i == instruments.count - 1 {
            completion(quotes)
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
        let instruments: Instruments = decode(json)!
        completion(instruments.results)
      }
    }
  }

  func fetchRobinhoodInstrumentWith(url: String, completion:@escaping ((Instrument) -> Void)) {
    Alamofire.request(url, method: .get).responseJSON { response in
      if let json = response.result.value {
        let object: Instrument = decode(json)!
        completion(object)
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

  //api.robinhood.com/fundamentals/{symbol}/
  func fetchRobinhoodFundamentalsWith(symbol: String, completion:@escaping ((Fundamentals) -> Void)) {
    let subURL = "fundamentals/" + symbol + "/"

    Alamofire.request(baseURL + subURL, method: .get).responseJSON { response in
      if let json = response.result.value {
        let object: Fundamentals = decode(json)!
        completion(object)
      }
    }
  }

  // MARK: Watchlist

  func fetchRobinhoodDefaultWatchlistWith(auth: Auth, completion:@escaping ((Watchlist) -> Void)) {
    let subURL = "watchlists/Default/"

    let headers = ["authorization": "token " + auth.token]

    Alamofire.request(baseURL + subURL, method: .get, headers:headers).responseJSON { response in
      if let json = response.result.value {
        let object: Watchlist = decode(json)!
        completion(object)
      }
    }
  }

}