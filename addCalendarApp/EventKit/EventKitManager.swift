//
//  EventKitManager.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/13.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class EventKitManager {
	
	private var _event: EKEvent?
	open var event: EKEvent? {
		get {
			return _event
		}
		set {
			_event = newValue
		}
	}
	
	private var _store: EKEventStore?
	open var store: EKEventStore? {
		get {
			return _store
		}
		set {
			_store = newValue
		}
	}
	
	init(_ ekEvent: EKEvent, _ ekEventStore: EKEventStore) {
		self.event = ekEvent
		self.store = ekEventStore
	}

	private func isAuthed() -> Bool {
		switch EKEventStore.authorizationStatus(for: .event) {
		case .authorized: return true
		case .denied: return false
		case .notDetermined: return false
		case .restricted: return false
		}
	}
	
	open func set(complation: ((Bool) -> ())?) {
		guard self.isAuthed() else {
			store?.requestAccess(to: .event, completion: {[weak self] granted, e in
				if granted {
					print("承認されました")
					complation?((self?.save())!)
				} else {
					print(e as Any)
					complation?(false)
				}
			})
			return
		}
		
		let isSaved: Bool = self.save()
		complation?(isSaved)
	}
	
	private func save() -> Bool {
		let defaultCalendar = store?.defaultCalendarForNewEvents
		event?.calendar = defaultCalendar
		do {
			try store?.save(event!, span: .thisEvent)
		} catch {
			return false
		}
		return true
	}
}
