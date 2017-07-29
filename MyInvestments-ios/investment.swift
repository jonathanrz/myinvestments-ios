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
	let dueDate: Date?
	let dateFormatter = DateFormatter()
	
	init(json: JSON) throws {
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000Z'"
		
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
		if let date = json["due_date"].string {
			self.dueDate = dateFormatter.date(from: date)
		} else {
			self.dueDate = nil
		}
	}
}
