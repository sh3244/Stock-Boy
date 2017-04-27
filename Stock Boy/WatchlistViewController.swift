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

class WatchlistViewController: ViewController, UISearchBarDelegate {
  var searchBar = SearchBar()
  var tableView = UITableView()
  var refreshControl = UIRefreshControl()

  var quotes: [Quote] = []
  var instruments: [Instrument] = []

  var selected: [IndexPath] = []

  var sortAscending = true
  var paused = false

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Watchlist"

    searchBar.delegate = self

    tableView.register(QuoteCell.self, forCellReuseIdentifier: "quoteCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .black
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

    view.sv([searchBar, tableView])

    let counter = myInterval(3)
    _ = counter
      .subscribe(onNext: { (value) in
        if !self.paused {
          self.refreshTable()
        }
    })

    navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(changeSort))]
    navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Paused", style: .plain, target: self, action: #selector(autoUpdate))]
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.layout(
      0,
      |searchBar|,
      |tableView|,
      0
    )
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
      if quote1.symbol > quote2.symbol {
        return sortAscending ? false : true
      }
      return sortAscending ? true : false
    })
    self.tableView.reloadData()
  }

  func refreshTable() {
    self.refreshControl.endRefreshing()

    if let auth = LoginManager.shared.auth {
      DataManager.shared.fetchRobinhoodDefaultWatchlistWith(auth: auth, completion: { watchlist in
        DataManager.shared.fetchRobinhoodInstrumentsWith(watchlist: watchlist.results, completion: { (instruments) in
          self.instruments = instruments
          DataManager.shared.fetchRobinhoodQuotesWith(instruments: instruments, completion: { (quotes) in
            self.quotes = quotes
            self.sort()
            self.tableView.reloadData()
          })
        })
      })
    }
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if let text = searchBar.text?.uppercased() {
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: text, completion: { (quote) in
        self.quotes.append(quote)
        self.tableView.reloadData()
      })
    }
  }

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }
}

extension WatchlistViewController : UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    if selected.contains(indexPath) {
      if let index = selected.index(of: indexPath) {
        selected.remove(at: index)

      }
    }
    else {
      selected.append(indexPath)

      let quote = quotes[indexPath.row]
      DispatchQueue.main.async {
        guard let url = chartURLFor(symbol: quote.symbol) else {
          return
        }

        let data = try! Data(contentsOf: url)
        if !data.isEmpty {
          if let quoteCell = tableView.cellForRow(at: indexPath) as? QuoteCell {
            quoteCell.chart.image = UIImage(data: data)
          }
        }
      }
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
      quoteCell.price.text = quote.last_trade_price.toUSD()
      quoteCell.change.changeTextTo(value: String(Double(quote.last_trade_price)! / Double(quote.adjusted_previous_close)!).toPercentChange())
      if quote.last_trade_price > quote.adjusted_previous_close {
        quoteCell.apply(color: .green)
      } else if quote.last_trade_price < quote.adjusted_previous_close {
        quoteCell.apply(color: .red)
      } else {
        quoteCell.apply(color: .gray)
      }
      DataManager.shared.fetchRobinhoodInstrumentWith(url: quote.instrument, completion: { (instrument) in
        quoteCell.name.text = instrument.name
      })
      DataManager.shared.fetchRobinhoodFundamentalsWith(symbol: quote.symbol, completion: { (fundamentals) in
        quoteCell.open.text = "Open: " + fundamentals.open.toUSD()
        quoteCell.high.text = "High: " + fundamentals.high.toUSD()
        quoteCell.low.text = "Low: " + fundamentals.low.toUSD()
        quoteCell.volume.text = "Vol: " + fundamentals.volume.toVolume()
        quoteCell.average_volume.text = "Avg Vol: " + fundamentals.average_volume.toVolume()
        quoteCell.high_52_weeks.text = "52 Week High: " + fundamentals.high_52_weeks.toUSD()
        quoteCell.low_52_weeks.text = "52 Week Low: " + fundamentals.low_52_weeks.toUSD()
        quoteCell.market_cap.text = "Cap: " + fundamentals.market_cap.toVolume()
      })
      if selected.contains(indexPath) {
        if quoteCell.chart.image != nil {
          return
        }
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

