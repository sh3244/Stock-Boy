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
import Alamofire

class ChartViewController: ViewController, SelectionViewDelegate {
  var chartView = LineChartView()
  var searchBar = SearchBar()
  var selectionView = SelectionView(["1W", "1Y", "5Y", "1W Vol", "1Y Vol"])

  convenience init(_ title: String, symbol: String) {
    self.init(title)
    searchBar.text = symbol
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    selectionView.delegate = self

    chartView.backgroundColor = .white
    chartView.gridBackgroundColor = .lightGray
    chartView.drawBordersEnabled = true
    chartView.pinchZoomEnabled = true
    chartView.setScaleEnabled(true)

    searchBlock = { string in
      DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: string, parameters: Historicals.oneWeekParameters()) { (historicals) in
        self.chartView.data = lineChartDataFrom(historicals: historicals)
        DataManager.shared.fetchRobinhoodInstrumentWith(url: historicals.instrument, completion: { (instrument) in
          self.chartView.chartDescription?.text = instrument.name
        })
      }
    }
    searchBlock(searchBar.text ?? "")

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Trade", style: .done, target: self, action: #selector(launchTrade))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([selectionView, searchBar, chartView])
    view.layout(
      0,
      |selectionView|,
      |searchBar|,
      |chartView|,
      0
    )
  }

  func launchTrade() {
    if let symbol = searchBar.text {
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: symbol, completion: { (quote) in
        let controller = TradeViewController(symbol, symbol: symbol)
        self.navigationController?.pushViewController(controller, animated: true)
      })
    }
  }

  override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchBar.text = searchText.uppercased()
  }

  // MARK: SelectionViewDelegate

  func selected(title: String) {
    switch title {
    case "1W":
      searchBlock = { string in
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: string, parameters: Historicals.oneWeekParameters()) { (historicals) in
          self.chartView.data = lineChartDataFrom(historicals: historicals)
        }
      }
    case "1Y":
      searchBlock = { string in
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: string, parameters: Historicals.oneYearParameters()) { (historicals) in
          self.chartView.data = lineChartDataFrom(historicals: historicals)
        }
      }
    case "5Y":
      searchBlock = { string in
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: string, parameters: Historicals.fiveYearParameters()) { (historicals) in
          self.chartView.data = lineChartDataFrom(historicals: historicals)
        }
      }
    case "1W Vol":
      searchBlock = { string in
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: string, parameters: Historicals.oneWeekParameters()) { (historicals) in
          self.chartView.data = volumeLineChartDataFrom(historicals: historicals)
        }
      }
    case "1Y Vol":
      searchBlock = { string in
        DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: string, parameters: Historicals.oneYearParameters()) { (historicals) in
          self.chartView.data = volumeLineChartDataFrom(historicals: historicals)
        }
      }
    default:
      break
    }

    searchBlock(searchBar.text ?? "")
  }

}
