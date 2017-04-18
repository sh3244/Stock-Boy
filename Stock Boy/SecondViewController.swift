//
//  SecondViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class SecondViewController: ViewController {
  var webView: UIWebView = UIWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .gray
    title = "Second"
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([webView])
    view.layout(
      0,
      |webView|,
      0
    )
  }
}

