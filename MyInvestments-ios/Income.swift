import Foundation
import SwiftyJSON

struct Income {
	let id: String
	let quantity: Double
	let value: Double
	let bought: Double
	let date: Date
	
	init(quantity: Double, value: Double, bought: Double, date: Date) {
		self.id = ""
		self.quantity = quantity
		self.value = value
		self.bought = bought
		self.date = date
	}
	
	init(json: JSON) throws {
		guard let id = json["_id"].string else {
			throw SerializationError.missing("_id")
		}
		guard let quantity = json["quantity"].double else {
			throw SerializationError.missing("quantity")
		}
		guard let value = json["value"].double else {
			throw SerializationError.missing("value")
		}
		guard let date = json["date"].string else {
			throw SerializationError.missing("date")
		}
		
		self.id = id
		self.quantity = quantity
		self.value = value
		if let bought = json["bought"].double {
			self.bought = bought
		} else {
			self.bought = 0
		}
		self.date = Server.dateFormatter.date(from: date)!
	}
	
	func toJSON() -> Dictionary<String, String> {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/yyyy"
		
		return [
			"quantity": String(format:"%.2f", self.quantity),
			"value": String(format:"%.2f", self.value),
			"bought": String(format:"%.2f", self.bought),
			"date": dateFormatter.string(from: date)
		]
	}
}
