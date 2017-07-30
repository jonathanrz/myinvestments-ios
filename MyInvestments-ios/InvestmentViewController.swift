import UIKit

class InvestmentViewController: UIViewController {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var holderImage: UIImageView!
	
	var server: Server? = nil
	let dateFormatter = DateFormatter()
	var investment: Investment?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		dateFormatter.dateFormat = "dd/MM/yyyy"
		
		if let investment = investment {
			nameLabel.text = investment.name
			nameLabel.text = investment.name
			typeLabel.text = investment.type
			if let dueDate = investment.dueDate {
				dateLabel.text = dateFormatter.string(from: dueDate)
			} else {
				dateLabel.text = ""
			}
			
			switch investment.holder {
			case "Bradesco":
				holderImage.image = #imageLiteral(resourceName: "bradesco")
			case "Easynvest":
				holderImage.image = #imageLiteral(resourceName: "easynvest")
			default:
				holderImage.image = #imageLiteral(resourceName: "unknown")
			}
			
			downloadIncomes(investment: investment)
		}
	}
	
	private func downloadIncomes(investment: Investment) {
		do {
			try server = Server()
			server?.downloadIncomes(investmentId: investment.id, completion: { (incomes, error) in
				if let incomes = incomes {
					print(incomes)
				} else {
					print(error!)
				}
			})
		} catch {
			print("Couldn't initialize server, possible missing of keys.plist")
		}
	}
}
