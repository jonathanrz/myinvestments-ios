import UIKit

class InvestmentViewController: UIViewController {
	@IBOutlet weak var nameLabel: UILabel!
	
	var investment: Investment?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let investment = investment {
			nameLabel.text = investment.name
		}
	}
}
