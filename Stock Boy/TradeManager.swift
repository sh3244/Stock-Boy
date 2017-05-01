//
//  TradeManager.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/30/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation

class TradeManager: NSObject {
  static let shared: TradeManager = {
    let instance = TradeManager()

    return instance
  }()

}
