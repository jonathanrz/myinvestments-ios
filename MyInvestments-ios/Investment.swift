import Foundation
import SwiftyJSON

struct Investment {
	let id: String
	let holder: String
	let name: String
	let type: String
	let dueDate: Date?
	
	init(name: String, type: String, holder: String) {
		self.id = ""
		self.name = name
		self.type = type
		self.holder = holder
		self.dueDate = nil
	}
	
	init(json: JSON) throws {
		guard let id = json["_id"].string else {
			throw SerializationError.missing("_id")
		}
		guard let holder = json["holder"].string else {
			throw SerializationError.missing("holder")
		}
		guard let name = json["name"].string else {
			throw SerializationError.missing("name")
		}
		guard let type = json["type"].string else {
			throw SerializationError.missing("type")
		}
		
		self.id = id
		self.holder = holder
		self.name = name
		self.type = type
		if let date = json["due_date"].string {
			self.dueDate = Server.dateFormatter.date(from: date)
		} else {
			self.dueDate = nil
		}
	}
}
