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

  func fetchRobinhoodInstruments(completion:@escaping (([Instrument]) -> Void)) {
    let subURL = "instruments/"
    Alamofire.request(baseURL + subURL, method: .get).responseJSON { response in
      if let json = response.result.value {
        let instruments: Instruments = decode(json)!
        completion(instruments.results)
      }
    }
  }

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

//  func updated(quote: Quote?) -> Quote {
//    if let quotee = quote {
//      let quoteURL = "quotes/" + quotee.symbol + "/"
//
//      Alamofire.request(baseURL + quoteURL, method: .get).responseJSON { response in
//        if let json = response.result.value {
//          let quoted: Quote = decode(json)!
//          return quoted
//        }
//      }
//    }
//    return quote
//  }
//
//  func update(quotes: [Quote], completion:@escaping (([Quote]) -> Void)) {
//    var newQuotes: [Quote] = []
//    quotes.forEach({ (quote) in
//      newQuotes.append(updated(quote: quote))
//    })
//
//  }

}
