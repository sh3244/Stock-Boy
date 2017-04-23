//
//  Watchlist.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/22/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Watchlist {
  var results: [WatchlistItem]
}

extension Watchlist: Decodable {
  static func decode(_ json: JSON) -> Decoded<Watchlist> {
    return curry(Watchlist.init)
      <^> json <|| "results"
  }
}

struct WatchlistItem {
  var watchlist: String
  var instrument: String
  var created_at: String
  var url: String
}

extension WatchlistItem: Decodable {
  static func decode(_ json: JSON) -> Decoded<WatchlistItem> {
    return curry(WatchlistItem.init)
      <^> json <| "watchlist"
      <*> json <| "instrument"
      <*> json <| "created_at"
      <*> json <| "url"
  }
}
