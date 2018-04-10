//
//  Match.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/10.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import Foundation

struct Match: Codable {
	let date: String
	let kickofftime: String
	let home: String
	let score: String?
	let away: String
	let place: String
	let note: String
}
