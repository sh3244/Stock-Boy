//
//  WatchlistViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia
import RxSwift

class WatchlistViewController: ViewController {
  let searchBar = SearchBar()
  let tableView = TableView()
  let refreshControl = UIRefreshControl()

  var quotes: [Quote] = []
  var instruments: [Instrument] = []

  var sortAscending = true
  var paused = false

  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar.delegate = self

    tableView.register(QuoteCell.self, forCellReuseIdentifier: "quoteCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Updating", style: .plain, target: self, action: #selector(autoUpdate))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(changeSort))

    searchBlock = { string in
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: string, completion: { (quote) in
        self.quotes.append(quote)
        self.tableView.reloadData()
      })
    }

    self.refreshTable()

    let counter = myInterval(3)
    _ = counter
      .subscribe(onNext: { (value) in
        if !self.paused {
          self.refreshTable()
        }
      })
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([tableView, searchBar])
    view.layout(
      0,
      |searchBar|,
      |tableView|,
      0
    )
  }

  func pullRefresh() {
    selected.removeAll()
    refreshTable()
  }

  func autoUpdate() {
    paused = !paused
    if paused {
      navigationItem.leftBarButtonItem?.title = "Paused"
    }
    else {
      navigationItem.leftBarButtonItem?.title = "Updating"
    }
  }

  func changeSort() {
    sortAscending = !sortAscending
    sort()
  }

  func sort() {
    self.quotes = self.quotes.sorted(by: { (quote1, quote2) -> Bool in
      let first = String((Double(quote1.last_trade_price) ?? 1) / (Double(quote1.adjusted_previous_close) ?? 1))
      let second = String((Double(quote2.last_trade_price) ?? 1) / (Double(quote2.adjusted_previous_close) ?? 1))
      if first < second {
        return sortAscending ? false : true
      }
      return sortAscending ? true : false
    })
  }

  func refreshTable() {
    refreshControl.endRefreshing()

    if let auth = LoginManager.shared.auth {
      DataManager.shared.fetchRobinhoodDefaultWatchlistWith(auth: auth, completion: { watchlist in
        DataManager.shared.fetchRobinhoodInstrumentsWith(watchlist: watchlist.results, completion: { (instruments) in
          self.instruments = instruments
          DataManager.shared.fetchRobinhoodQuotesWith(instruments: instruments, completion: { (quotes) in
            self.quotes = quotes
            self.sort()
            self.tableView.reloadData()
            self.revealView(self.tableView)
          })
        })
      })
    }
  }
}

extension WatchlistViewController : UITableViewDataSource {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    if selected.contains(indexPath) {
      if let index = selected.index(of: indexPath) {
        selected.remove(at: index)

        // TODO
//        let quote = quotes[indexPath.row]
//        let chart = ChartViewController(quote.symbol, symbol: quote.symbol)
//        self.navigationController?.pushViewController(chart, animated: true)
      }
    }
    else {
      selected.append(indexPath)
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as? QuoteCell

    return cell ?? QuoteCell()
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let quote = quotes[indexPath.row]

    if let quoteCell = cell as? QuoteCell {
      quoteCell.symbol.text = quote.symbol
      quoteCell.price.text = quote.last_trade_price
      quoteCell.change.text = String((Double(quote.last_trade_price) ?? 1) - (Double(quote.adjusted_previous_close) ?? 1))
      quoteCell.changePercent.text = String((Double(quote.last_trade_price) ?? 1) / (Double(quote.adjusted_previous_close) ?? 1))
      DataManager.shared.fetchRobinhoodInstrumentWith(url: quote.instrument, completion: { (instrument) in
        quoteCell.name.text = instrument.name
      })
      DataManager.shared.fetchRobinhoodFundamentalsWith(symbol: quote.symbol, completion: { (fundamentals) in
        quoteCell.open.text = fundamentals.open
        quoteCell.high.text = fundamentals.high
        quoteCell.low.text = fundamentals.low
        quoteCell.volume.text = fundamentals.volume
        quoteCell.average_volume.text = fundamentals.average_volume
        quoteCell.high_52_weeks.text = fundamentals.high_52_weeks
        quoteCell.low_52_weeks.text = fundamentals.low_52_weeks
        quoteCell.market_cap.text = fundamentals.market_cap
      })
      if selected.contains(indexPath) {
        guard let url = chartURLFor(symbol: quote.symbol) else {
          return
        }
        quoteCell.chart.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
      }
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if selected.contains(indexPath) {
      return QuoteCell.expandedHeightValue
    }
    return QuoteCell.heightValue
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quotes.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}

