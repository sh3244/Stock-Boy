//
//  Account.swift
//  Stock Boy
//
//  Created by Sam on 4/24/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Accounts {
  var results: [Account]
}

extension Accounts: Decodable {
  static func decode(_ json: JSON) -> Decoded<Accounts> {
    return curry(Accounts.init)
      <^> json <|| "results"
  }
}

struct Account {
  var updated_at: String
  var margin_balances: MarginBalance
  var portfolio: String
  var cash_available_for_withdrawal: String

  var type: String
  var sma: String
  var buying_power: String
  var user: String

  var max_ach_early_access_amount: String
  var url: String
  var positions: String
  var created_at: String

  var cash: String
  var account_number: String
  var unsettled_funds: String
}

extension Account: Decodable {
  static func decode(_ json: JSON) -> Decoded<Account> {
    let f = curry(Account.init)
      <^> json <| "updated_at"
      <*> json <| "margin_balances"
      <*> json <| "portfolio"
      <*> json <| "cash_available_for_withdrawal"
      <*> json <| "type"
    return f
      <*> json <| "sma"
      <*> json <| "buying_power"
      <*> json <| "user"
      <*> json <| "max_ach_early_access_amount"
      <*> json <| "url"
      <*> json <| "positions"
      <*> json <| "created_at"
      <*> json <| "cash"
      <*> json <| "account_number"
      <*> json <| "unsettled_funds"
  }
}

struct MarginBalance {
  var day_trade_buying_power: String
  var start_of_day_overnight_buying_power: String
  var cash_held_for_orders: String

  var created_at: String
  var start_of_day_dtbp: String
  var day_trade_buying_power_held_for_orders: String
  var overnight_buying_power: String

  var cash: String
  var unallocated_margin_cash: String
  var updated_at: String
  var cash_available_for_withdrawal: String

  var margin_limit: String
  var unsettled_funds: String
  var day_trade_ratio: String
  var overnight_ratio: String
}

extension MarginBalance: Decodable {
  static func decode(_ json: JSON) -> Decoded<MarginBalance> {
    let f = curry(MarginBalance.init)
      <^> json <| "day_trade_buying_power"
      <*> json <| "start_of_day_overnight_buying_power"
      <*> json <| "cash_held_for_orders"
      <*> json <| "created_at"
      <*> json <| "start_of_day_dtbp"
    return f
      <*> json <| "day_trade_buying_power_held_for_orders"
      <*> json <| "overnight_buying_power"
      <*> json <| "cash"
      <*> json <| "unallocated_margin_cash"
      <*> json <| "updated_at"
      <*> json <| "cash_available_for_withdrawal"
      <*> json <| "margin_limit"
      <*> json <| "unsettled_funds"
      <*> json <| "day_trade_ratio"
      <*> json <| "overnight_ratio"
  }
}
