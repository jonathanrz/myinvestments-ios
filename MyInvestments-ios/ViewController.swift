//
//  ViewController.swift
//  MyInvestments-ios
//
//  Created by Jonathan Zanella on 24/07/17.
//  Copyright © 2017 Jonathan Zanella. All rights reserved.
//

import UIKit

func getEnvironmentVar(_ name: String) -> String? {
	guard let rawValue = getenv(name) else { return nil }
	return String(utf8String: rawValue)
}

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
