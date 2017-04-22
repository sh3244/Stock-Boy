//
//  Auth.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Auth {
  var token: String
}

extension Auth: Decodable {
  static func decode(_ json: JSON) -> Decoded<Auth> {
    return curry(Auth.init)
      <^> json <| "token"
  }
}
