//
//  Position.swift
//  Stock Boy
//
//  Created by Sam on 4/27/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Positions {
  var results: [Position]
}

extension Positions: Decodable {
  static func decode(_ json: JSON) -> Decoded<Positions> {
    return curry(Positions.init)
      <^> json <|| "results"
  }
}

struct Position {
  var account: String
  var intraday_quantity: String
  var intraday_average_buy_price: String
  var url: String
  var created_at: String
  var updated_at: String
  var shares_held_for_buys: String
  var average_buy_price: String
  var instrument: String
  var shares_held_for_sells: String
  var quantity: String
}

extension Position: Decodable {
  static func decode(_ json: JSON) -> Decoded<Position> {
    let f = curry(Position.init)
      <^> json <| "account"
      <*> json <| "intraday_quantity"
      <*> json <| "intraday_average_buy_price"
      <*> json <| "url"
    return f
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <| "shares_held_for_buys"
      <*> json <| "average_buy_price"
      <*> json <| "instrument"
      <*> json <| "shares_held_for_sells"
      <*> json <| "quantity"
  }
}
