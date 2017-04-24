//
//  Instrument.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Instruments {
  var results: [Instrument]
}

extension Instruments: Decodable {
  static func decode(_ json: JSON) -> Decoded<Instruments> {
    return curry(Instruments.init)
      <^> json <|| "results"
  }
}

struct Instrument {
  var splits: String
  var margin_initial_ratio: String
  var url: String
  var quote: String
  var symbol: String
  var bloomberg_unique: String
  var fundamentals: String
  var state: String
  var day_trade_ratio: String
  var tradeable: Bool
  var maintenance_ratio: String
  var id: String
  var market: String
  var name: String
}

extension Instrument: Decodable {
  static func decode(_ json: JSON) -> Decoded<Instrument> {
    let f = curry(Instrument.init)
      <^> json <| "splits"
      <*> json <| "margin_initial_ratio"
      <*> json <| "url"
      <*> json <| "quote"
      <*> json <| "symbol"
    return f
      <*> json <| "bloomberg_unique"
      <*> json <| "fundamentals"
      <*> json <| "state"
      <*> json <| "day_trade_ratio"
      <*> json <| "tradeable"
      <*> json <| "maintenance_ratio"
      <*> json <| "id"
      <*> json <| "market"
      <*> json <| "name"
  }
}
