//
//  MatchListViewController.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/06.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftDate
import EventKit
import ToastSwiftFramework

protocol MatchListViewControllerDelegate: NSObjectProtocol {
	func matchListViewController(_ vc: MatchListViewController, backButton didTapped: UIButton)
}

class MatchListViewController: UIViewController {

	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var matchTableView: UITableView!
	
  private var tableView: UITableView!
  private let matchTableViewCell = MatchTableViewCell()
  
	private var fixture: Fixture? {
		didSet{
			setTableView()
		}
	}
	
	weak var delegate: MatchListViewControllerDelegate?
	
	enum Sections: Int {
		case headers, body
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		
		getMatchs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
	}
	
	private func setTableView() {
		matchTableView.delegate = self
		matchTableView.dataSource = self
		matchTableView.register(UINib(nibName: matchTableViewCell.Identifier, bundle: nil),
                                forCellReuseIdentifier: matchTableViewCell.Identifier)
		matchTableView.tableFooterView = UIView(frame: .zero)
		view.addSubview(matchTableView)
	}
	
	// MARK:- Private
	
	private func getMatchs() {
      let url = "http://labs.s-koichi.info/api/jleague/V2/schedule"
      let params =  ["year":"2018", "league": "j1"]
      
		Alamofire.request(url, parameters: params).responseJSON(completionHandler: {[weak self] responce in
			guard case .success(_) = responce.result, let data = responce.data,
              let fixtures = try? JSONDecoder().decode(Fixture.self, from: data) else {
				
				return
			}
			self?.fixture = fixtures
		})
	}
	
	private func getDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> DateInRegion? {
		var cmp = DateComponents()
		cmp.year = year
		cmp.month = month
		cmp.day = day
		cmp.hour = hour
		cmp.minute = minute
		return DateInRegion(components: cmp)
	}
	
	private func setEventWith(MatchTableViewCell cell: MatchTableViewCell, start: Date, end: Date) {
		let eventStore = EKEventStore()
		let event = EKEvent(eventStore: eventStore)
		if let match = cell.match {
			event.title = match.home + " vs " + match.away
		}
		event.startDate = start
		event.endDate = end
		event.location = cell.match?.place

		let alert = UIAlertController(title: "確認", message: "この試合をカレンダーに登録しますか？\n" + event.title, preferredStyle: .alert)
		let okAction: UIAlertAction = UIAlertAction(title: "OK",
													style: .default, handler: {_ in
														let manager = EventKitManager(event, eventStore)
														manager.set(complation: {bool in
															guard bool else {
																return
															}
															self.view.makeToast("登録完了", duration: 2.0, position: .bottom)
														})
		})
		let falseAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
		alert.addAction(okAction)
		alert.addAction(falseAction)
		
		self.present(alert, animated: true, completion: nil)		
	}
	
	@objc func back(sender: UIButton) {
		delegate?.matchListViewController(self, backButton: sender)
	}
}

// MARK:- UITableViewDataSource

extension MatchListViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return fixture!.sec.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
		return fixture!.sec[section].sec
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fixture!.sec[section].match.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: matchTableViewCell.Identifier,
                                                 for: indexPath) as! MatchTableViewCell
		let match = fixture!.sec[indexPath.section].match[indexPath.row]
		cell.match = match
		
		let year = Int(fixture!.year)!
		let date: Array = match.date.components(separatedBy: "/")
		let time: Array = match.kickofftime.components(separatedBy: ":")
		if let month: Int = Int(date[0]),
			let day: Int = Int(date[1]),
			let hour: Int = Int(time[0]),
			let minute: Int = Int(time[1]),
			let startDate = getDate(year, month, day, hour, minute) {
			cell.startDate = startDate
			print(startDate.isAfter(date: DateInRegion(), granularity: .calendar))
			
		}
		return cell
	}
	
}

// MARK:- UITableViewDelegate

extension MatchListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 80
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: matchTableViewCell.Identifier,
													   for: indexPath) as? MatchTableViewCell,
			let startDate = cell.startDate else {
				return
		}

		let endDate = startDate + 2.hours
		self.setEventWith(MatchTableViewCell: cell, start: startDate.absoluteDate, end: endDate.absoluteDate)
	}
	
}


