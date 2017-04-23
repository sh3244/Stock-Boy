//
//  Fundamentals.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Fundamentals {
  var open: String
  var high: String
  var low: String
  var volume: String
  var average_volume: String
  var high_52_weeks: String
  var dividend_yield: String?
  var low_52_weeks: String
  var market_cap: String
  var pe_ratio: String?
  var description: String
  var instrument: String
}

extension Fundamentals: Decodable {
  static func decode(_ json: JSON) -> Decoded<Fundamentals> {
    let f = curry(Fundamentals.init)
      <^> json <| "open"
      <*> json <| "high"
      <*> json <| "low"
      <*> json <| "volume"
      <*> json <| "average_volume"
    return f
      <*> json <| "high_52_weeks"
      <*> json <|? "dividend_yield"
      <*> json <| "low_52_weeks"
      <*> json <| "market_cap"
      <*> json <|? "pe_ratio"
      <*> json <| "description"
      <*> json <| "instrument"
  }
}
