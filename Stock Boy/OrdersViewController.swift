//
//  OrdersViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class OrdersViewController: ViewController, UITableViewDataSource {
  var tableView = TableView()
  var refreshControl = UIRefreshControl()
  let headerView = HeaderView(["Symbol", "Type", "Shares", "Price", "Value", "Status"], [50, 50, 50, 50, 50, -50])

  var items: [Order] = []

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(OrderCell.self, forCellReuseIdentifier: "orderCell")
    tableView.refreshControl = refreshControl
    tableView.dataSource = self
    tableView.delegate = self
    refreshControl.rx.controlEvent(.valueChanged)
      .subscribe { _ in
        self.update()
        self.refreshControl.endRefreshing()
      }
      .addDisposableTo(disposeBag)

    let counter = myInterval(15)
    _ = counter
      .subscribe(onNext: { (value) in
        self.update()
      })
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([headerView, tableView])
    view.layout(
      0,
      |headerView|,
      |tableView|,
      0
    )
  }

  func update() {
    if let auth = LoginManager.shared.auth {
      DataManager.shared.fetchRobinhoodOrdersWith(auth: auth, completion: { (orders) in
        self.items = orders
        self.tableView.reloadData()
        self.revealView(self.tableView)
      })
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let order = items[indexPath.row]
    DataManager.shared.fetchRobinhoodInstrumentWith(url: order.instrument, completion: { (instrument) in
      let controller = TradeViewController(instrument.symbol, symbol: instrument.symbol)
      self.navigationController?.pushViewController(controller, animated: true)
    })
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderCell

    return cell ?? OrderCell()
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let order = items[indexPath.row]

    if let orderCell = cell as? OrderCell {
      DataManager.shared.fetchRobinhoodInstrumentWith(url: order.instrument, completion: { (instrument) in
        orderCell.symbol.text = instrument.symbol
      })
      orderCell.type.text = order.side
      orderCell.quantity.text = order.quantity
      orderCell.price.text = order.price ?? ""

      if let quantity = Double(order.quantity), let price = Double(order.price ?? "") {
        orderCell.cost.text = String(quantity * price)
      }

      orderCell.status.text = order.state
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if selected.contains(indexPath) {
      return OrderCell.expandedHeightValue
    }
    return OrderCell.heightValue
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
}
