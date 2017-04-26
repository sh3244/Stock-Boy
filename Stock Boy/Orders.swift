//
//  Orders.swift
//  Stock Boy
//
//  Created by Sam on 4/24/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Orders {
  var results: [Order]
}

extension Orders: Decodable {
  static func decode(_ json: JSON) -> Decoded<Orders> {
    return curry(Orders.init)
      <^> json <|| "results"
  }
}

struct Order {
  var updated_at: String
  var time_in_force: String
  var cancel: String
  var id: String
  var cumulative_quantity: String
  var stop_price: String?
  var instrument: String
  var state: String
  var trigger: String
  var type: String
  var price: String
  var url: String
  var side: String
  var position: String
  var average_price: String?
  var quantity: String
}

extension Order: Decodable {
  static func decode(_ json: JSON) -> Decoded<Order> {
    let f = curry(Order.init)
      <^> json <| "updated_at"
      <*> json <| "time_in_force"
      <*> json <| "cancel"
      <*> json <| "id"
      <*> json <| "cumulative_quantity"
    return f
      <*> json <|? "stop_price"
      <*> json <| "instrument"
      <*> json <| "state"
      <*> json <| "trigger"
      <*> json <| "type"
      <*> json <| "price"
      <*> json <| "url"
      <*> json <| "side"
      <*> json <| "position"
      <*> json <|? "average_price"
      <*> json <| "quantity"
  }
}

import Alamofire

struct OrderRequest {
  var account: String
  var instrument: String
  var symbol: String
  var price: Float
  var quantity: Int

  enum OrderType {
    case limit
    case market
  }
  var type: OrderType

  enum TimeInForceType {
    case gfd
    case gtc
    case ioc
    case fok
    case opg
  }
  var time_in_force: TimeInForceType

  enum TriggerType {
    case immediate
    case stop
  }
  var trigger: TriggerType

  enum SideType {
    case buy
    case sell
  }
  var side: SideType

  func typeValue() -> String {
    switch type {
    case .limit:
      return "limit"
    case .market:
      return "market"
    }
  }

  func timeInForceValue() -> String {
    switch time_in_force {
    case .gfd:
      return "gfd"
    case .gtc:
      return "gtc"
    case .ioc:
      return "ioc"
    case .fok:
      return "fok"
    case .opg:
      return "opg"
    }
  }

  func triggerValue() -> String {
    switch trigger {
    case .immediate:
      return "immediate"
    case .stop:
      return "stop"
    }
  }

  func sideValue() -> String {
    switch side {
    case .buy:
      return "buy"
    case .sell:
      return "sell"
    }
  }

  func parameters() -> Parameters {
    let parameters: Parameters = [
      "account": account,
      "instrument": instrument,
      "symbol": symbol,
      "type": typeValue(),
      "time_in_force": timeInForceValue(),
      "trigger": triggerValue(),
      "price": price,
      "quantity": quantity,
      "side": sideValue()
    ]
    return parameters
  }
}
