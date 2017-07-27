//
//  ViewController.swift
//  MyInvestments-ios
//
//  Created by Jonathan Zanella on 24/07/17.
//  Copyright © 2017 Jonathan Zanella. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyPlistManager
import SwiftyJSON

func getEnvironmentVar(_ name: String) -> String? {
	guard let rawValue = getenv(name) else { return nil }
	return String(utf8String: rawValue)
}

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		SwiftyPlistManager.shared.start(plistNames: ["keys"], logging: true)
		guard
			let authToken = SwiftyPlistManager.shared.fetchValue(for: "auth-token", fromPlistWithName: "keys"),
			let serverUrl = SwiftyPlistManager.shared.fetchValue(for: "server-url", fromPlistWithName: "keys")
			else { return }
		
		let headers: HTTPHeaders = [
			"auth-token": authToken as! String,
			"Accept": "application/json"
		]
		
		Alamofire.request(serverUrl as! String, headers: headers)
			.responseJSON { response in
				var investments: [Investment] = []
				if((response.result.value) != nil) {
					let swiftyJsonVar = JSON(response.result.value!)
					print(swiftyJsonVar)
					
					for case let result in swiftyJsonVar.arrayObject! {
						do {
							try investments.append(Investment(json: JSON(result)))
						} catch(SerializationError.missing(let error)) {
							print(error)
						} catch(SerializationError.invalid(let error, _)) {
							print(error)
						} catch _ {
							
						}
					}
				}
				
				print(investments)
			}
			.responseString { response in
				if let error = response.result.error {
					print(error)
				}
				if let value = response.result.value {
					print(value)
				}
			}
	}
}
