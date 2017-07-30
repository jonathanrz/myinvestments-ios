import UIKit
import os.log

class NewIncomeViewController: UIViewController {
	@IBOutlet weak var date: UIDatePicker!
	@IBOutlet weak var quantityTextView: UITextField!
	@IBOutlet weak var valueTextView: UITextField!
	@IBOutlet weak var boughtTextView: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	var lastIncome: Income?
	var income: Income?

    override func viewDidLoad() {
        super.viewDidLoad()

		if let lastIncome = lastIncome {
			quantityTextView.text = String(format:"%.2f", lastIncome.quantity)
			valueTextView.text = String(format:"%.2f", lastIncome.value)
			boughtTextView.text = String(format:"%.2f", lastIncome.bought)
		}
    }
	
    // MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		guard let button = sender as? UIBarButtonItem, button === saveButton else {
			os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
			return
		}
		
		let quantity = quantityTextView.text!
		let value = valueTextView.text!
		let bought = boughtTextView.text!
		let date = self.date.date
		income = Income(quantity: Double(quantity)!, value: Double(value)!, bought: Double(bought)!, date: date)
	}
}
