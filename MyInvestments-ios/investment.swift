//
//  investment.swift
//  MyInvestments-ios
//
//  Created by Jonathan Zanella on 26/07/17.
//  Copyright © 2017 Jonathan Zanella. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SerializationError: Error {
	case missing(String)
	case invalid(String, Any)
}

struct Investment {
	let holder: String
	let name: String
	let type: String
	
	init(json: JSON) throws {
		guard let holder = json["holder"].string else {
			throw SerializationError.missing("holder")
		}
		guard let name = json["name"].string else {
			throw SerializationError.missing("name")
		}
		guard let type = json["type"].string else {
			throw SerializationError.missing("type")
		}
		
		self.holder = holder
		self.name = name
		self.type = type
	}
}
