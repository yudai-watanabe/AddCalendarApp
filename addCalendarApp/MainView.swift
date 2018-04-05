//
//  MainView.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/04.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit
import EventKit

class MainView: UIView {
	
	private let mainLabel: UILabel
	
	private let button: UIButton
	
	private let eventStore = EKEventStore()
	
	override init(frame: CGRect) {
		self.mainLabel = UILabel()
		self.button = UIButton()
		
		super.init(frame: frame)
		self.backgroundColor = .white
		self.button.addTarget(self, action: #selector(self.tapped(_:)), for: .touchUpInside)
		
		self.addSubview(mainLabel)
		self.addSubview(button)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.configurMainLabel()
		self.configurButton()
	}
	
	private func configurMainLabel() {
		self.mainLabel.textAlignment = .center
		let labelSize = self.mainLabel.sizeThatFits(self.bounds.size)
		
		let x = (self.bounds.width - labelSize.width) / 2
		let y = (self.bounds.height - labelSize.height) / 2
		let labelOrigin = CGPoint(x: x, y: y)
		
		self.mainLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
	}
	
	private func configurButton() {
		self.button.setTitle("Add Your Calendar!!", for: .normal)
		self.button.setTitleColor(.white, for: .normal)
		self.button.layer.masksToBounds = true
		self.button.backgroundColor = .blue
		
		let buttonSize = self.button.sizeThatFits(self.bounds.size)
		let buttonX = (self.bounds.width - buttonSize.width) / 2
		let buttonY = (self.bounds.height - buttonSize.height) / 2
		let buttonOrigin = CGPoint(x: buttonX, y: buttonY + 100)
		
		self.button.layer.cornerRadius = buttonSize.height / 2
		self.button.frame = CGRect(origin: buttonOrigin, size: buttonSize)
	}
	
	internal func setTitle(title: String) {
		mainLabel.text = title
	}
	
	@objc internal func tapped(_ sender: AnyObject) {
		guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
			eventStore.requestAccess(to: .event, completion: { isCompleted, error in
				print(isCompleted)
				print(error as Any)
			})
			return
		}
		
	}
}
