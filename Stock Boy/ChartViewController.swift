//
//  ChartViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia
import Charts

class ChartViewController: ViewController, UISearchBarDelegate {
  var chartView = LineChartView()
  var searchBar = SearchBar()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chart"
    searchBar.delegate = self
    searchBar.text = "URRE"
    view.sv([searchBar, chartView])

    chartView.backgroundColor = .white
    chartView.gridBackgroundColor = .lightGray
    chartView.drawBordersEnabled = true
    chartView.pinchZoomEnabled = true
    chartView.setScaleEnabled(true)
    chartView.chartDescription?.text = "Stock Boy"

    DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: searchBar.text!) { (historicals) in
      self.chartView.data = lineChartDataFrom(historicals: historicals)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.layout(
      0,
      |searchBar|,
      |chartView|,
      0
    )
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: searchBar.text!) { (historicals) in
      self.chartView.data = lineChartDataFrom(historicals: historicals)
    }
  }

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

  }

}
