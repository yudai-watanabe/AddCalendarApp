//
//  MainView.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/04.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit

protocol MainViewDelegate: NSObjectProtocol {
	func mainView(_ mainView: MainView, button didTapped: UIButton)
	func mainView(_ mainView: MainView, transitionButton didTapped: UIButton)
}

class MainView: UIView {
	
	private let mainLabel = UILabel()
	private let button = UIButton()
	private let transitionButton = UIButton()
	weak var delegate: MainViewDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .white
		self.button.addTarget(self, action: #selector(self.tappedButton(_:)), for: .touchUpInside)
		self.transitionButton.addTarget(self, action: #selector(self.tappedTransitionButton(_:)), for: .touchUpInside)
		
		self.addSubview(mainLabel)
		self.addSubview(button)
		self.addSubview(transitionButton)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.configurMainLabel()
		self.configurButton()
		self.configureTransitionButton()
	}
	
	private func configureTransitionButton() {
		self.transitionButton.setTitle("tap", for: .normal)
		self.transitionButton.setTitleColor(.black, for: .normal)
		
		let buttonSize = self.transitionButton.sizeThatFits(self.bounds.size)
		let buttonX = (self.bounds.width - buttonSize.width) / 2
		let buttonOrigin = CGPoint(x: buttonX, y: 30)
		
		self.transitionButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
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
	
	@objc internal func tappedButton(_ button: UIButton) {
		delegate?.mainView(self, button: button)
	}
	
	@objc internal func tappedTransitionButton(_ transitionButton: UIButton) {
		delegate?.mainView(self, transitionButton: transitionButton)
	}
}
