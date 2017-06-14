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

class ChartViewController: ViewController, SelectionViewDelegate, ChartViewDelegate {
  let chartView = LineChartView()
  let searchBar = SearchBar()
  let selectionView = SelectionView(["1W", "1Y", "5Y", "1W Vol", "1Y Vol"])
  let chart = ImageView(frame: .zero)

  let priceIndicator = Label("price", type: .usd, prefix: "Price: ")

  convenience init(_ title: String, symbol: String) {
    self.init(title)
    searchBar.text = symbol
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    selectionView.delegate = self

    priceIndicator.textColor = .blue
    priceIndicator.shouldBlink = false

    chartView.backgroundColor = .white
    chartView.gridBackgroundColor = .lightGray
    chartView.drawBordersEnabled = true
    chartView.pinchZoomEnabled = true
    chartView.setScaleEnabled(true)
    chartView.delegate = self

    searchBlock = { string in
      DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: string, parameters: Historicals.oneWeekParameters()) { (historicals) in
        self.chartView.data = lineChartDataFrom(historicals: historicals)
        DataManager.shared.fetchRobinhoodInstrumentWith(url: historicals.instrument, completion: { (instrument) in
          self.chartView.chartDescription?.text = instrument.name
        })

        guard let url = chartURLFor(symbol: string) else {
          return
        }
        self.chart.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
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
    view.sv([selectionView, searchBar, chartView, priceIndicator, chart])
    view.layout(
      0,
      |searchBar|,
      |selectionView|,
      8,
      |chartView|,
      8,
      |chart| ~ 320,
      0
    )
    priceIndicator.Top == chartView.Top + 20
    priceIndicator.Left == chartView.Left + 45
  }

  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    priceIndicator.text = String(entry.y)
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
