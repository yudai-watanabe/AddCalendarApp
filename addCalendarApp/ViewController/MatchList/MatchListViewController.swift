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
	
	private func setEventWithMatch(_ match: Match, start: Date, end: Date) {
		let eventStore = EKEventStore()
		let event = EKEvent(eventStore: eventStore)
		event.title = match.home + " vs " + match.away
		event.startDate = start
		event.endDate = end
		event.location = match.place

		let alert = UIAlertController(title: "確認", message: "このイベントを登録しますか？\n" + event.title, preferredStyle: .alert)
		let okAction: UIAlertAction = UIAlertAction(title: "OK",
													style: .default, handler: {_ in
														let manager = EventKitManager(event, eventStore)
														manager.set(complation: {bool in
															guard bool else {
																return
															}
															print("セーブできたよ")
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
		let section = indexPath.section
		let row = indexPath.row
		let match = fixture!.sec[section].match[row]
        let nullScore = "0-0"
      
		cell.date.text = match.date
		cell.time.text = match.kickofftime
		cell.home.text = match.home
		cell.score.text = match.score ?? nullScore
		cell.away.text = match.away
		cell.venue.text = match.place
		return cell
	}
	
}

extension MatchListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 80
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard  let match = fixture?.sec[indexPath.section].match[indexPath.row],
			let year: Int = Int((fixture?.year)!) else {
			return
		}
		let date: Array = match.date.components(separatedBy: "/")
		let time: Array = match.kickofftime.components(separatedBy: ":")
		
		if let month: Int = Int(date[0]),
			let day: Int = Int(date[1]),
			let hour: Int = Int(time[0]),
			let minute: Int = Int(time[1]),
			let startDate = getDate(year, month, day, hour, minute) {
			
			let endDate = startDate + 2.hours
			self.setEventWithMatch(match, start: startDate.absoluteDate, end: endDate.absoluteDate)
		}
	}
	
}


