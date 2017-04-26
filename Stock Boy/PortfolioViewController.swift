//
//  PortfolioViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Stevia

class PortfolioViewController: ViewController, UITableViewDataSource, UITableViewDelegate {

  var tableView = UITableView()
  var refreshControl = UIRefreshControl()

  var selected: [IndexPath] = []

  var items: [Order] = []

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Portfolio"

    //    tableView.register(OrderCell.self, forCellReuseIdentifier: "orderCell")
    tableView.backgroundColor = .black
    tableView.refreshControl = refreshControl
    tableView.dataSource = self
    tableView.delegate = self
    refreshControl.rx.controlEvent(.valueChanged)
      .subscribe { _ in
        self.update()
        self.refreshControl.endRefreshing()
      }
      .addDisposableTo(disposeBag)

    let orders = DataManager.shared.orders
    orders.asObservable()
      .subscribe({ (orders) in
        if let ords = orders.element?.first?.results {
          self.items = ords
          self.tableView.reloadData()
        }
      })
      .addDisposableTo(disposeBag)

    update()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([tableView])
    view.layout(
      0,
      |tableView|,
      0
    )
  }

  func update() {
    DataManager.shared.fetchRobinhoodAuthWith { (auth) in
      DataManager.shared.fetchRobinhoodOrdersWith(auth: auth, completion: { (orders) in
        DataManager.shared.orders.value.append(Orders(results: orders))
      })
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    if selected.contains(indexPath) {
      if let index = selected.index(of: indexPath) {
        selected.remove(at: index)

      }
    }
    else {
      selected.append(indexPath)
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = PortfolioCell()

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let order = items[indexPath.row]

    if let portfolioCell = cell as? PortfolioCell {
      DataManager.shared.fetchRobinhoodInstrumentWith(url: order.instrument, completion: { (instrument) in
        portfolioCell.symbol.text = instrument.symbol
      })
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if selected.contains(indexPath) {
      return PortfolioCell.expandedHeightValue
    }
    return PortfolioCell.heightValue
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

}
