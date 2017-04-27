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
import RxSwift

class ChartViewController: ViewController, UISearchBarDelegate, SelectionViewDelegate {
  var chartView = LineChartView()
  var searchBar = SearchBar()
  var selection = SelectionView(["1W", "1Y", "5Y", "1W Vol", "1Y Vol"])

  var fetchBlock: (() -> Void) = {}

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chart"
    searchBar.delegate = self
    searchBar.text = "URRE"
    view.sv([selection, searchBar, chartView])

    chartView.backgroundColor = .white
    chartView.gridBackgroundColor = .lightGray
    chartView.drawBordersEnabled = true
    chartView.pinchZoomEnabled = true
    chartView.setScaleEnabled(true)
    chartView.chartDescription?.text = "Stock Boy"

    fetchBlock = {
      DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: self.searchBar.text!, parameters: Historicals.oneWeekParameters()) { (historicals) in
        self.chartView.data = lineChartDataFrom(historicals: historicals)
      }
    }
    self.fetchBlock()

    selection.delegate = self

    let counter = myInterval(10.0)
    _ = counter
      .subscribe(onNext: { (value) in
        self.fetchBlock()
      })
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.layout(
      0,
      |selection|,
      |searchBar|,
      |chartView|,
      0
    )
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    fetchBlock()
  }

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

  }

  // MARK: SelectionViewDelegate

  func selected(title: String) {
    switch title {
    case "1W":
      fetchBlock = {
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: self.searchBar.text!, parameters: Historicals.oneWeekParameters()) { (historicals) in
          self.chartView.data = lineChartDataFrom(historicals: historicals)
        }
      }
    case "1Y":
      fetchBlock = {
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: self.searchBar.text!, parameters: Historicals.oneYearParameters()) { (historicals) in
          self.chartView.data = lineChartDataFrom(historicals: historicals)
        }
      }
    case "5Y":
      fetchBlock = {
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: self.searchBar.text!, parameters: Historicals.fiveYearParameters()) { (historicals) in
          self.chartView.data = lineChartDataFrom(historicals: historicals)
        }
      }
    case "1W Vol":
      fetchBlock = {
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: self.searchBar.text!, parameters: Historicals.oneWeekParameters()) { (historicals) in
          self.chartView.data = volumeLineChartDataFrom(historicals: historicals)
        }
      }
    case "1Y Vol":
      fetchBlock = {
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: self.searchBar.text!, parameters: Historicals.oneYearParameters()) { (historicals) in
          self.chartView.data = volumeLineChartDataFrom(historicals: historicals)
        }
      }
    default:
      return
    }
    self.fetchBlock()
  }

}
