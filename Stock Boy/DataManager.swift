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
    let quoteURL = "quotes/" + symbol + "/"

    Alamofire.request(baseURL + quoteURL, method: .get).responseJSON { response in
      if let json = response.result.value {
        let quote: Quote = decode(json)!
        completion(quote)
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
