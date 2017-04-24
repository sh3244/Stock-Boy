//
//  ChartManager.swift
//  Stock Boy
//
//  Created by Sam on 4/24/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Charts

func lineChartDataSetFrom(historicals: Historicals) -> LineChartDataSet {
  var entries: [ChartDataEntry] = []
  var index = 0.0
  for historical in historicals.historicals {
    if let price = Double(historical.close_price) {
      entries.append(ChartDataEntry(x: index, y: price))
    }
    index += 1/78
  }
  let set = LineChartDataSet(values: entries, label: historicals.symbol + " price")
  set.setColor(.blue)
  set.drawCirclesEnabled = false
  set.highlightColor = .gray
  return set
}

func lineChartDataFrom(historicals: Historicals) -> LineChartData {
  let data = LineChartData(dataSet: lineChartDataSetFrom(historicals: historicals))
  data.setDrawValues(true)
  return data
}
