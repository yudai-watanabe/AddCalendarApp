//
//  UIViewController + instantiateFromStoryboard.swift
//  addCalendarApp
//
//  Created by watanabe-yudai on 2018/04/09.
//  Copyright © 2018年 watanabe-yudai. All rights reserved.
//

import UIKit

extension UIViewController {
	
	open class func instantiateFromStoryboardName(_ name: String) -> UIViewController? {
		let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
		return storyboard.instantiateInitialViewController()
	}
	
	open class func instantiateFromStoryboard() -> UIViewController? {
		let clsName = NSStringFromClass(self)
		if let name = clsName.components(separatedBy: ".").last {
			return instantiateFromStoryboardName(name)
		}
		
		return nil
	}
	
}
