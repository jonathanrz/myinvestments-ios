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
	
	let serverUrl: String
	let headers: HTTPHeaders
	
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
	
	public func createInvestment(investment: Investment, completion: @escaping (Investment?, Error?) ->()) {
		Alamofire.request(serverUrl + "/investments", method: .post, parameters: investment.toJSON(), encoding: JSONEncoding.default, headers: headers)
			.responseJSON { response in
				print(response)
				let swiftyJsonVar = JSON(response.result.value!)
			
				do {
					try completion(Investment(json: JSON(swiftyJsonVar.object)), nil)
				} catch(SerializationError.missing(let error)) {
					print(error)
				} catch(SerializationError.invalid(let error, _)) {
					print(error)
				} catch _ {
					
				}
			}
	}
	
	public func downloadIncomes(investmentId: String, completion: @escaping ([Income]?, String?) ->()) {
		let path = "/investments/" + investmentId + "/income"
		Alamofire.request(serverUrl + path, headers: headers)
			.responseJSON { response in
				var incomes = [Income]()
				if((response.result.value) != nil) {
					let swiftyJsonVar = JSON(response.result.value!)
					print(swiftyJsonVar)
					
					for case let result in swiftyJsonVar.arrayObject! {
						do {
							try incomes.append(Income(json: JSON(result)))
						} catch(SerializationError.missing(let error)) {
							completion(nil, error)
						} catch(SerializationError.invalid(let error, _)) {
							completion(nil, error)
						} catch _ {
						}
					}
				}
				
				completion(incomes, nil)
			}
			.responseString { response in
				if let error = response.result.error {
					completion(nil, error.localizedDescription)
				}
				if let value = response.result.value {
					completion(nil, value)
				}
		}
	}
	
	public func createInvestment(investmentId: String, income: Income, completion: @escaping (Income?, Error?) ->()) {
		let path = "/investments/" + investmentId + "/income"
		Alamofire.request(serverUrl + path, method: .post, parameters: income.toJSON(), encoding: JSONEncoding.default, headers: headers)
			.responseJSON { response in
				print(response)
				let swiftyJsonVar = JSON(response.result.value!)
				
				do {
					try completion(Income(json: JSON(swiftyJsonVar.object)), nil)
				} catch(SerializationError.missing(let error)) {
					print(error)
				} catch(SerializationError.invalid(let error, _)) {
					print(error)
				} catch _ {
					
				}
		}
	}
}
