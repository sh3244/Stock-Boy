//
//  ImageView.swift
//  Stock Boy
//
//  Created by Sam on 4/23/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class ImageView: UIImageView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentMode = .scaleAspectFit
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
