//
//  DataManager.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/20/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Argo
import Alamofire

public let baseURL = "https://api.robinhood.com/"

class DataManager: NSObject {

  static let shared: DataManager = {
    let instance = DataManager()

    return instance
  }()

  func fetchRobinhoodAuthWith(completion:@escaping (Auth) -> ()) {
    let parameters: Parameters = ["username": "sh3244",
                                  "password": "5ezypqj9omp"
    ]

    Alamofire.request(baseURL + "api-token-auth/", method: .post, parameters: parameters).responseJSON { response in
      if let json = response.result.value {
        let auth: Auth = decode(json)
        completion(auth)
      }
    }
  }

  func fetchCatalogResponse() -> BallResponse {
    let empty = BallResponse(GameStates: [], Players: [], PlayerStats: [], Teams: [], Games: [])

    guard let path = Bundle.main.path(forResource: "basketballdata", ofType: "json") else {
      return empty
    }

    guard let data = NSData(contentsOfFile: path) else {
      return empty
    }
    do {
      if let results = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSDictionary {
        let gameStates: [GameState] = decode(results["Game State"]!)!
        let players: [Player] = decode(results["Players"]!)!
        let playerStats: [PlayerStat] = decode(results["Player Stats"]!)!
        let teams: [Team] = decode(results["Teams"]!)!
        let games: [Game] = decode(results["Games"]!)!

        let response = BallResponse(GameStates: gameStates, Players: players, PlayerStats: playerStats, Teams: teams, Games: games)
        return response
      }

    } catch {

    }
    return empty
  }
}
