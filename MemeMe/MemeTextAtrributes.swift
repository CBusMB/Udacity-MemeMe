//
//  MemeTextAtrributes.swift
//  MemeMe
//
//  Created by Matthew Brown on 5/9/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import UIKit

struct MemeTextAttributes {
  
  static let attributes = [
    NSStrokeColorAttributeName: UIColor.blackColor(),
    NSForegroundColorAttributeName: UIColor.whiteColor(),
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -1.0
  ]
  
  static let inCellAttributes = [
    NSStrokeColorAttributeName: UIColor.blackColor(),
    NSForegroundColorAttributeName: UIColor.whiteColor(),
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
    NSStrokeWidthAttributeName : -1.0
  ]
  
}
