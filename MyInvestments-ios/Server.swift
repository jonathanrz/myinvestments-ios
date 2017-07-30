import Foundation
import Alamofire
import SwiftyPlistManager
import SwiftyJSON

enum InitializationError: Error {
	case invalidKeys()
}

class Server {
	static var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000Z'"
		return formatter
	}
	
	let headers: HTTPHeaders
	let serverUrl: String
	
	init() throws {
		SwiftyPlistManager.shared.start(plistNames: ["keys"], logging: true)
		
		guard
			let authToken = SwiftyPlistManager.shared.fetchValue(for: "auth-token", fromPlistWithName: "keys"),
			let serverUrl = SwiftyPlistManager.shared.fetchValue(for: "server-url", fromPlistWithName: "keys")
			else { throw InitializationError.invalidKeys() }
		
		self.serverUrl = serverUrl as! String
		self.headers = [
			"auth-token": authToken as! String,
			"Accept": "application/json"
		]
	}
	
	public func downloadInvestments(completion: @escaping ([Investment]?, Error?) ->()) {
		Alamofire.request(serverUrl + "/investments", headers: headers)
			.responseJSON { response in
				var investments = [Investment]()
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
				
				completion(investments, nil)
			}
			.responseString { response in
				if let error = response.result.error {
					completion(nil, error)
				}
				if let value = response.result.value {
					print(value)
				}
		}
	}
}
