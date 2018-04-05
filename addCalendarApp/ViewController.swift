//
//  ViewController.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/04.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, MainViewDelegate {
	
	private let eventStore = EKEventStore()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let mainView = MainView(frame: self.view.bounds)
		mainView.delegate = self
		mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		mainView.setTitle(title: "Add Calendar App")
		
		self.view.addSubview(mainView)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Private
	
	private func isAuthed() -> Bool {
		switch EKEventStore.authorizationStatus(for: .event) {
		case .authorized: return false
		case .denied: return false
		case .notDetermined: return false
		case .restricted: return true
		}
	}
	
	// MARK: - MainViewDelegate
	
	func mainView(_ mainView: MainView, didTapped button: UIButton) {
		guard self.isAuthed() else {
			eventStore.requestAccess(to: .event, completion: { isCompleted, error in
				print(isCompleted)
				print(error as Any)
			})
			return
		}
	}
}

