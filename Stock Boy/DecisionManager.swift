//
//  DecisionManager.swift
//  Stock Boy
//
//  Created by Samuel Huang on 6/17/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation

struct Proposal {
  var symbol: String = ""
  var targetBegin: String = ""
  var targetMax: String = ""
  var targetMin: String = ""
  var gain: String = ""
  var loss: String = ""
  var risk: String = ""
  var volatility: String = ""
  var targetTimeInDays: String = ""
  var averages: [String: String] = [:]
  var volumes: [String: String] = [:]
  var derivatives: [String] = []
  var averagesArray: [String] = []
  var volumesArray: [String] = []
}

class DecisionManager: NSObject {

  let group = DispatchGroup()

  static let shared: DecisionManager = {
    let instance = DecisionManager()

    return instance
  }()

  func getTrendingPrice(historicals: Historicals, units: Int) -> Float {
    var average: Float = 0
    var values: [Float] = []

    var index = 0
    for historical in historicals.historicals.reversed() {
      if index == units {
        continue;
      }
      let open = historical.open_price.floatValueLow()
      let close = historical.close_price.floatValueLow()
      let low = historical.low_price.floatValueLow()
      let high = historical.high_price.floatValueLow()

      let normal = (open + close) / 2
      let swing = (low + high) / 2

      let value = ((normal * 2) + swing) / 3
      values.append(value)
      index += 1
    }

    for value in values {
      average += value
    }

    return average / (Float(exactly: values.count) ?? 1.0)
  }

  func getVolume(historicals: Historicals, units: Int) -> Float {
    var average: Float = 0
    var values: [Float] = []

    var index = 0
    for historical in historicals.historicals.reversed() {
      if index == units {
        continue;
      }
      values.append(Float(historical.volume))
      index += 1
    }

    for value in values {
      average += value
    }

    return average / (Float(exactly: values.count) ?? 1.0)
  }

  func generateProposalFor(symbol: String, completion: @escaping ((Proposal) -> Void)) {
    var proposal = Proposal()
    let timeLengths = [1, 5, 10, 30, 90, 180, 360]
    // One Year Parameters 252, Date last year to Date today
    DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: symbol, parameters: Historicals.oneYearParameters()) { (historicals) in
      let lastHistorical = historicals.historicals.last

      var averages: [Float] = []
      var volumes: [Float] = []
      for timeLength in timeLengths {
        proposal.averages[timeLength.description] = self.getTrendingPrice(historicals: historicals, units: timeLength).description
        proposal.volumes[timeLength.description] = self.getVolume(historicals: historicals, units: timeLength).description

        averages.append(self.getTrendingPrice(historicals: historicals, units: timeLength))
        volumes.append(self.getVolume(historicals: historicals, units: timeLength))
      }

      averages = averages.reversed()
      volumes = volumes.reversed()

      var derivatives:[Float] = []
      for index in 1...averages.count - 1 {
        let derivative = averages[index] - averages[index-1]
        derivatives.append(derivative)
      }

      let positiveDerivatives = derivatives.filter({ (derivative) -> Bool in
        if derivative > 0.0 {
          return true
        }
        return false
      })

      let negativeDerivatives = derivatives.filter({ (derivative) -> Bool in
        if derivative < 0.0 {
          return true
        }
        return false
      })


      let maxDerivative = derivatives.max() ?? 0.0
      let maxAverage = averages.max() ?? 0.0

      let minDerivative = derivatives.min() ?? 0.0
      let minAverage = averages.min() ?? 0.0

      let avgAverage = (minAverage + maxAverage)/2
      let avgDerivative = (minDerivative + maxDerivative)/2

      let lastPrice = ((lastHistorical?.open_price.floatValueLow() ?? 0) + (lastHistorical?.close_price.floatValueLow() ?? 0)) / 2

      let volatility = ((maxDerivative - avgDerivative) + (avgDerivative - minDerivative)) / 2

      var risk = ((Float(negativeDerivatives.count) - Float(positiveDerivatives.count)) / 6)

      var lowBall = lastPrice + (avgDerivative + minDerivative) / 2
      var highBall = lastPrice + (avgDerivative + maxDerivative) / 2

      if avgAverage < lowBall {
        lowBall = avgAverage
      }
      if avgAverage > highBall {
        highBall = avgAverage
      }

      let derivativesStrings = derivatives.flatMap({ (value) -> String in
        return String(format: "%.2f", value).toUSD()
      })

      let volumesStrings = volumes.flatMap({ (value) -> String in
        return String(format: "%.2f", value).toVolume()
      })

      let averagesStrings = averages.flatMap({ (value) -> String in
        return String(format: "%.2f", value).toUSD()
      })

      proposal.targetBegin = String(format: "%.2f", lastPrice)
      proposal.targetMax = String(format: "%.2f", highBall)
      proposal.targetMin = String(format: "%.2f", lowBall)
      proposal.targetTimeInDays = String(format: "%.2f", 10)
      proposal.derivatives = derivativesStrings
      proposal.averagesArray = averagesStrings
      proposal.volumesArray = volumesStrings
      proposal.volatility = String(format: "%.2f", volatility)
      proposal.loss = String(format: "%.2f", (lowBall / lastPrice))
      proposal.gain = String(format: "%.2f", (highBall / lastPrice))
      proposal.symbol = symbol

      risk += ((lowBall / lastPrice) - (highBall / lastPrice)) / 10
      proposal.risk = String(format: "%.2f", risk)
      completion(proposal)
    }
  }

  func generateProposalsFor(quotes: [Quote], completion: @escaping (([Proposal]) -> Void)) {
    var proposals: [Proposal] = []
    for quote in quotes {
      group.enter()
      generateProposalFor(symbol: quote.symbol, completion: { (proposal) in
        proposals.append(proposal)
        self.group.leave()
      })
    }
    group.notify(queue: .main) { 
      completion(proposals)
    }
  }
}
