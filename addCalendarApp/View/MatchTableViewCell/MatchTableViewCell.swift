//
//  MatchTableViewCell.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/10.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

  open let Identifier: String = "MatchTableViewCell"
  
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var time: UILabel!
	@IBOutlet weak var home: UILabel!
	@IBOutlet weak var away: UILabel!
	@IBOutlet weak var score: UILabel!
	@IBOutlet weak var venue: UILabel!

}
