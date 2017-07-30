import UIKit
import os.log

class NewInvestmentViewController: UIViewController {
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var nameTextView: UITextField!
	@IBOutlet weak var typeTextView: UITextField!
	@IBOutlet weak var holderTextView: UITextField!
	
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
		
		investment = Investment(name: name, type: type, holder: holder)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
