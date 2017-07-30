import UIKit

class InvestmentsTableViewController: UITableViewController {
	static var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter
	}
	
	var investments: [Investment] = []
	var server: Server?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		do {
			try server = Server()
			server?.downloadInvestments(completion: { (investments, error) in
				if let investments = investments {
					self.investments = investments
					self.tableView.reloadData()
				}
			})
		} catch {
			print("Couldn't initialize server, possible missing of keys.plist")
		}
		
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return investments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentTableViewCell", for: indexPath) as? InvestmentTableViewCell else {
			fatalError("The dequeued cell is not an instance of InvestmentTableViewCell.")
		}
		
		let investment = investments[indexPath.row]
		
		cell.nameLabel.text = investment.name
		cell.typeLabel.text = investment.type
		if let dueDate = investment.dueDate {
			cell.dateLabel.text = InvestmentsTableViewController.dateFormatter.string(from: dueDate)
		} else {
			cell.dateLabel.text = ""
		}
		
		switch investment.holder {
		case "Bradesco":
			cell.logoImage.image = #imageLiteral(resourceName: "bradesco")
		case "Easynvest":
			cell.logoImage.image = #imageLiteral(resourceName: "easynvest")
		default:
			cell.logoImage.image = #imageLiteral(resourceName: "unknown")
		}

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
		
		switch(segue.identifier ?? "") {
			case "ShowInvestment":
				guard let investmentViewController = segue.destination as? InvestmentViewController else {
					fatalError("Unexpected destination: \(segue.destination)")
				}
				
				guard let selectedCell = sender as? InvestmentTableViewCell else {
					fatalError("Unexpected sender: \(sender ?? "nil")")
				}
				
				guard let indexPath = tableView.indexPath(for: selectedCell) else {
					fatalError("The selected cell is not being displayed by the table")
				}
				
				let selectedInvestment = investments[indexPath.row]
				investmentViewController.investment = selectedInvestment
			case "AddInvestment":
				break
		default:
			fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil")")
		}
    }
}
