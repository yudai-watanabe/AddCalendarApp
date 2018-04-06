//
//  MatchListViewController.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/06.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit
import Alamofire


class MatchListViewController: UIViewController {

	enum Sections: Int {
		case headers, body
	}
	
	var request: Alamofire.Request? {
		didSet {
			oldValue?.cancel()
			
			title = request?.description
			
		}
	}
	
	var headers: [String: String] = [:]
	var body: String?
	var elapsedTime: TimeInterval?
	var segueIdentifier: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// TODO: 通信させる
		
		
		// TODO: 毎節ごとに表示させる
		//tableView??
		

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
