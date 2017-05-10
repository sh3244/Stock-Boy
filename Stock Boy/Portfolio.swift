//
//  Portfolio.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Portfolios {
  var results: [Portfolio]
}

extension Portfolios: Decodable {
  static func decode(_ json: JSON) -> Decoded<Portfolios> {
    return curry(Portfolios.init)
      <^> json <|| "results"
  }
}

struct Portfolio {
  var account: String
  var url: String
  var excess_maintenance: String
  var market_value: String
  var withdrawable_amount: String
  var excess_margin: String
  var equity: String
  var adjusted_equity_previous_close: String
  var equity_previous_close: String
  var start_date: String
}

extension Portfolio: Decodable {
  static func decode(_ json: JSON) -> Decoded<Portfolio> {
    return curry(Portfolio.init)
      <^> json <| "account"
      <*> json <| "url"
      <*> json <| "excess_maintenance"
      <*> json <| "market_value"
      <*> json <| "withdrawable_amount"
      <*> json <| "excess_margin"
      <*> json <| "equity"
      <*> json <| "adjusted_equity_previous_close"
      <*> json <| "equity_previous_close"
      <*> json <| "start_date"
  }
}
