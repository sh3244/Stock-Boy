//
//  ChartManager.swift
//  Stock Boy
//
//  Created by Sam on 4/24/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Charts

func closeLineChartDataSetFrom(historicals: Historicals) -> LineChartDataSet {
  var entries: [ChartDataEntry] = []
  var index = 0.0
  for historical in historicals.historicals {
    if let price = Double(historical.close_price) {
      entries.append(ChartDataEntry(x: index, y: price))
    }
    index += 1/78
  }
  let set = LineChartDataSet(values: entries, label: historicals.symbol + " close price")
  set.setColor(.gray)
  set.mode = .stepped
  set.drawCirclesEnabled = false
  set.highlightColor = .gray
  return set
}

func highLineChartDataSetFrom(historicals: Historicals) -> LineChartDataSet {
  var entries: [ChartDataEntry] = []
  var index = 0.0
  for historical in historicals.historicals {
    if let price = Double(historical.high_price) {
      entries.append(ChartDataEntry(x: index, y: price))
    }
    index += 1/78
  }
  let set = LineChartDataSet(values: entries, label: historicals.symbol + " high price")
  set.setColor(UISettings.goodColor)
  set.mode = .stepped
  set.drawCirclesEnabled = false
  set.highlightColor = .gray
  return set
}

func lowLineChartDataSetFrom(historicals: Historicals) -> LineChartDataSet {
  var entries: [ChartDataEntry] = []
  var index = 0.0
  for historical in historicals.historicals {
    if let price = Double(historical.low_price) {
      entries.append(ChartDataEntry(x: index, y: price))
    }
    index += 1/78
  }
  let set = LineChartDataSet(values: entries, label: historicals.symbol + " low price")
  set.setColor(UISettings.badColor)
  set.mode = .stepped
  set.drawCirclesEnabled = false
  set.highlightColor = .gray
  return set
}

func volumeLineChartDataSetFrom(historicals: Historicals) -> LineChartDataSet {
  var entries: [ChartDataEntry] = []
  var index = 0.0
  for historical in historicals.historicals {
    entries.append(ChartDataEntry(x: index, y: Double(historical.volume)))
    index += 1/78
  }
  let set = LineChartDataSet(values: entries, label: historicals.symbol + " volume")
  set.setColor(UISettings.neutralColor)
  set.mode = .stepped
  set.drawCirclesEnabled = false
  set.highlightColor = .gray
  return set
}

func lineChartDataFrom(historicals: Historicals) -> LineChartData {
  let data = LineChartData(dataSets: [
      closeLineChartDataSetFrom(historicals: historicals),
      highLineChartDataSetFrom(historicals: historicals),
      lowLineChartDataSetFrom(historicals: historicals)
    ])
  data.setDrawValues(true)
  return data
}

func volumeLineChartDataFrom(historicals: Historicals) -> LineChartData {
  let data = LineChartData(dataSets: [
    volumeLineChartDataSetFrom(historicals: historicals)
    ])
  data.setDrawValues(true)
  return data
}

