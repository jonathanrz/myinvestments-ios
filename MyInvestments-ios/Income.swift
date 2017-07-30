import Foundation
import SwiftyJSON

struct Income {
	let id: String
	let value: Double
	let quantity: Double
	let date: Date?
	
	init(json: JSON) throws {
		guard let id = json["_id"].string else {
			throw SerializationError.missing("_id")
		}
		guard let value = json["value"].string else {
			throw SerializationError.missing("value")
		}
		guard let quantity = json["quantity"].string else {
			throw SerializationError.missing("quantity")
		}
		guard let date = json["date"].string else {
			throw SerializationError.missing("date")
		}
		
		self.id = id
		self.value = Double(value)!
		self.quantity = Double(quantity)!
		self.date = Server.dateFormatter.date(from: date)
	}
}
