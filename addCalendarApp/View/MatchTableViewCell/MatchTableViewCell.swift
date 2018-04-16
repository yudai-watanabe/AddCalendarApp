//
//  MatchTableViewCell.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/10.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit
import SwiftDate

class MatchTableViewCell: UITableViewCell {

	open let Identifier: String = "MatchTableViewCell"
	open var startDate: DateInRegion?
	private let nullScore = "0-0"
	open var match: Match? {
		didSet {
			date.text = match?.date
			time.text = match?.kickofftime
			home.text = match?.home
			score.text = match?.score ?? nullScore
			away.text = match?.away
			venue.text = match?.place
		}
	}
  
	@IBOutlet private weak var date: UILabel!
	@IBOutlet private weak var time: UILabel!
	@IBOutlet private weak var home: UILabel!
	@IBOutlet private weak var away: UILabel!
	@IBOutlet private weak var score: UILabel!
	@IBOutlet private weak var venue: UILabel!

}
