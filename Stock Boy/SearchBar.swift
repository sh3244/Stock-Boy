//
//  SearchBar.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {

  override init(frame: CGRect) {
    super.init(frame: frame)
    searchBarStyle = .minimal
    tintColor = UISettings.foregroundColor
    backgroundColor = UISettings.backgroundColor
    returnKeyType = .search

    let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField
    textFieldInsideSearchBar?.textColor = UISettings.foregroundColor

    let textFieldInsideSearchBarLabel = textFieldInsideSearchBar?.value(forKey: "placeholderLabel") as? UILabel
    textFieldInsideSearchBarLabel?.textColor = UISettings.foregroundColor
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
