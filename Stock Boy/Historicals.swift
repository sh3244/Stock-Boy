//
//  Historicals.swift
//  Stock Boy
//
//  Created by Sam on 4/23/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes
import Alamofire

struct Historicals {
  var quote: String
  var symbol: String
  var interval: String
  var span: String
  var bounds: String
  var instrument: String
  var historicals: [Historical]

  public static func oneWeekParameters() -> Parameters {
    let parameters: Parameters = [
      "interval": "5minute",
      "span": "week",
      "bounds": "regular"
    ]
    return parameters
  }

  public static func oneYearParameters() -> Parameters {
    let parameters: Parameters = [
      "interval": "day",
      "span": "year",
      "bounds": "regular"
    ]
    return parameters
  }

  public static func fiveYearParameters() -> Parameters {
    let parameters: Parameters = [
      "interval": "week",
      "span": "5year",
      "bounds": "regular"
    ]
    return parameters
  }
}

extension Historicals: Decodable {
  static func decode(_ json: JSON) -> Decoded<Historicals> {
    let f = curry(Historicals.init)
      <^> json <| "quote"
      <*> json <| "symbol"
      <*> json <| "interval"
      <*> json <| "span"
      <*> json <| "bounds"
    return f
      <*> json <| "instrument"
      <*> json <|| "historicals"
  }
}

struct Historical {
  var begins_at: String
  var open_price: String
  var close_price: String
  var high_price: String
  var low_price: String
  var volume: Int
  var session: String
  var interpolated: Bool
}

extension Historical: Decodable {
  static func decode(_ json: JSON) -> Decoded<Historical> {
    let f = curry(Historical.init)
      <^> json <| "begins_at"
      <*> json <| "open_price"
      <*> json <| "close_price"
      <*> json <| "high_price"
      <*> json <| "low_price"
    return f
      <*> json <| "volume"
      <*> json <| "session"
      <*> json <| "interpolated"
  }
}
