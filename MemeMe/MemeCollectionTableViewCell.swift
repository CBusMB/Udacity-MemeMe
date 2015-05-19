//
//  MemeCollectionTableViewCell.swift
//  MemeMe
//
//  Created by Matthew Brown on 5/18/15.
//  Copyright (c) 2015 Crest Technologies. All rights reserved.
//

import UIKit

class MemeCollectionTableViewCell: UITableViewCell
{
  @IBOutlet weak var memeImageView: UIImageView!
  @IBOutlet weak var topTextLabel: UILabel!
  @IBOutlet weak var bottomTextLabel: UILabel!
  @IBOutlet weak var mainTextLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
    
}
