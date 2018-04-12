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

protocol MatchListViewControllerDelegate: NSObjectProtocol {
	func matchListViewController(_ vc: MatchListViewController, backButton didTapped: UIButton)
}

class MatchListViewController: UIViewController {

	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var matchTableView: UITableView!
	
  private var tableView: UITableView!
  private let matchTableViewCell = MatchTableViewCell()
  
	private var year: Year? {
		didSet{
          if  let date: Array = year?.sec[0].match[0].date.components(separatedBy: "/") {
            let month: String = date[0]
            let day: String = date[1]
            let stringDate: String = year!.year + "-" + month + "-" + day + " " + year!.sec[0].match[0].kickofftime
            let startDate = stringDate.date(format: .custom("yyyy-MM-dd HH:MM"))
            self.date.text = String(describing: startDate?.day)
          }
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
              let matchs = try? JSONDecoder().decode(Year.self, from: data) else {
				return
			}
			self?.year = matchs
		})
	}
	
	@objc func back(sender: UIButton) {
		delegate?.matchListViewController(self, backButton: sender)
	}
}

extension MatchListViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return year!.sec.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
		return year!.sec[section].sec
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return year!.sec[section].match.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: matchTableViewCell.Identifier,
                                                 for: indexPath) as! MatchTableViewCell
		let section = indexPath.section
		let row = indexPath.row
		let match = year!.sec[section].match[row]
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
		print(indexPath)
	}
	
}


