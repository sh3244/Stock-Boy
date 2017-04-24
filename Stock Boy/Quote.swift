//
//  Quote.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Quotes {
  var results: [Quote]
}

extension Quotes: Decodable {
  static func decode(_ json: JSON) -> Decoded<Quotes> {
    return curry(Quotes.init)
      <^> json <|| "results"
  }
}

struct Quote {
  var ask_price: String
  var ask_size: Int
  var bid_price: String
  var bid_size: Int
  var last_trade_price: String
  var last_extended_hours_trade_price: String?
  var previous_close: String
  var adjusted_previous_close: String
  var previous_close_date: String
  var symbol: String
  var trading_halted: Bool
  var has_traded: Bool
  var last_trade_price_source: String
  var updated_at: String
  var instrument: String
}

extension Quote: Decodable {
  static func decode(_ json: JSON) -> Decoded<Quote> {
    let f = curry(Quote.init)
      <^> json <| "ask_price"
      <*> json <| "ask_size"
      <*> json <| "bid_price"
      <*> json <| "bid_size"
      <*> json <| "last_trade_price"
    return f
      <*> json <|? "last_extended_hours_trade_price"
      <*> json <| "previous_close"
      <*> json <| "adjusted_previous_close"
      <*> json <| "previous_close_date"
      <*> json <| "symbol"
      <*> json <| "trading_halted"
      <*> json <| "has_traded"
      <*> json <| "last_trade_price_source"
      <*> json <| "updated_at"
      <*> json <| "instrument"
  }
}
