//
//  MatchListViewController.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/06.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit
import Alamofire

protocol MatchListViewControllerDelegate: NSObjectProtocol {
	func matchListViewController(_ vc: MatchListViewController, backButton didTapped: UIButton)
}

class MatchListViewController: UIViewController {

	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var matchTableView: UITableView!
	private var tableView: UITableView!
	
	private var year: Year? {
		didSet{
			print("受信完了")
			self.date.text = year?.sec[0].match[0].date
			setTableView()
		}
	}
	
	weak var delegate: MatchListViewControllerDelegate?
	
	enum Sections: Int {
		case headers, body
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// TODO: 毎節ごとに表示させる
		self.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		
		getMatchs("http://labs.s-koichi.info/api/jleague/V2/schedule",
				  params: ["year":"2018", "league": "j1"])
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
		matchTableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchTableViewCell")
		matchTableView.tableFooterView = UIView(frame: .zero)
		view.addSubview(matchTableView)
	}
	
	private func getMatchs(_ url: String, params: [String:String]) {
		Alamofire.request(url, parameters: params).responseJSON(completionHandler: {[weak self]res in
			guard case .success(_) = res.result,
				let data = res.data,
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
		let cell = tableView.dequeueReusableCell(withIdentifier: "MatchTableViewCell", for: indexPath) as! MatchTableViewCell
		let section = indexPath.section
		let row = indexPath.row
		let match = year!.sec[section].match[row]
		
		cell.date.text = match.date
		cell.time.text = match.kickofftime
		cell.home.text = match.home
		cell.score.text = match.score ?? "0-0"
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


