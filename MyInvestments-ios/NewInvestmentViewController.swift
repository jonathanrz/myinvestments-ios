import UIKit
import os.log

class NewInvestmentViewController: UIViewController {
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var nameTextView: UITextField!
	@IBOutlet weak var typeTextView: UITextField!
	@IBOutlet weak var holderTextView: UITextField!
	@IBOutlet weak var dueDatePicker: UIDatePicker!
	
	var investment: Investment?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		guard let button = sender as? UIBarButtonItem, button === saveButton else {
			os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
			return
		}
		
		let name = nameTextView.text ?? ""
		let type = typeTextView.text ?? ""
		let holder = holderTextView.text ?? ""
		let dueDate = dueDatePicker.date
		if dueDate > Date() {
			investment = Investment(name: name, type: type, holder: holder, dueDate: dueDate)
		} else {
			investment = Investment(name: name, type: type, holder: holder)
		}
	}

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
}
