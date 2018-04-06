//
//  ViewController.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/04.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit
import EventKit
import SwiftDate

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
		self.view = nil
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
	
	private func addEvent() {
		let startDate = Date()
		let cal = Calendar(identifier: Calendar.Identifier.gregorian)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		let endDate = cal.date(byAdding: .hour, value: 2, to: startDate)
		let title = "テストイベント"
		let defaultCalendar = eventStore.defaultCalendarForNewEvents
		
		let event = EKEvent(eventStore: eventStore)
		event.title = title
		event.startDate = startDate
		event.endDate = endDate
		event.calendar = defaultCalendar
		
		do {
			try eventStore.save(event, span: .thisEvent)
		} catch let error {
			print(error)
			print("セーブ失敗したよ")
			return
		}
		print("セーブできたよ")
	}
	
	// MARK: - MainViewDelegate
	
	func mainView(_ mainView: MainView, transitionButton: UIButton) {
		print("タップ")
	}
	
	func mainView(_ mainView: MainView, button: UIButton) {
		guard self.isAuthed() else {
			eventStore.requestAccess(to: .event, completion: {[weak self] granted, e in
				if granted {
					self?.addEvent()
				} else {
					print(e as Any)
				}
			})
			return
		}
		self.addEvent()
	}
}

