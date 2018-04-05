//
//  ViewController.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/04.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		let mainView = MainView(frame: self.view.bounds)
		
		mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		mainView.setTitle(title: "Add Calendar App")
		
		self.view.addSubview(mainView)
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

