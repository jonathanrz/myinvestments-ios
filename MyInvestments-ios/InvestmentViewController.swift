import UIKit
import Charts

class InvestmentViewController: UIViewController, IAxisValueFormatter, IValueFormatter {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var holderImage: UIImageView!
	@IBOutlet weak var incomesValueChart: LineChartView!
	@IBOutlet weak var investmentValueChart: LineChartView!
	
	var server: Server? = nil
	let dateFormatter = DateFormatter()
	var investment: Investment?
	var incomes: [Income]? = nil

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
            case "Clear":
                holderImage.image = #imageLiteral(resourceName: "clear")
            case "Monetus":
                holderImage.image = #imageLiteral(resourceName: "monetus")
			default:
				holderImage.image = #imageLiteral(resourceName: "unknown")
			}
			
			downloadIncomes(investment: investment)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		switch(segue.identifier ?? "") {
		case "AddIncome":
			guard let viewController = segue.destination as? NewIncomeViewController else {
				fatalError("Unexpected destination: \(segue.destination)")
			}
			if let incomes = incomes {
				if incomes.count > 0 {
					viewController.lastIncome = incomes[incomes.count - 1]
				}
			}
			
			break
		default:
			fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil")")
		}
	}
	
	@IBAction func unwindToInvestment(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? NewIncomeViewController, let income = sourceViewController.income {
			
			server?.createInvestment(investmentId: investment!.id, income: income, completion: { (income, error) in
				if let income = income {
					self.incomes!.append(income)
					self.populateCharts(self.incomes!)
				} else {
					print(error!)
				}
			})
		}
	}
	
	private func downloadIncomes(investment: Investment) {
		do {
			try server = Server()
			server?.downloadIncomes(investmentId: investment.id, completion: { (incomes, error) in
				if let incomes = incomes {
					self.incomes = incomes.sorted(by: { $0.date.compare($1.date) == ComparisonResult.orderedAscending })
					self.populateCharts(self.incomes!)
				} else {
					print(error!)
				}
			})
		} catch {
			print("Couldn't initialize server, possible missing of keys.plist")
		}
	}
	
	private func populateCharts(_ incomes: [Income]) {
		populateIncomeValueChart(incomes)
		populateInvestmentValueChart(incomes)
	}
	
	private func populateIncomeValueChart(_ incomes: [Income]) {
		var dataEntries: [ChartDataEntry] = []
		
		for income in incomes {
			dataEntries.append(ChartDataEntry(x: income.date.timeIntervalSince1970, y: income.value))
		}
		
		let chartDataSet = LineChartDataSet(values: dataEntries, label: "Income value")
		let chartData = LineChartData(dataSet: chartDataSet)
		chartData.setValueFormatter(self)
		incomesValueChart.data = chartData
		incomesValueChart.xAxis.valueFormatter = self
		incomesValueChart.leftAxis.valueFormatter = self
		incomesValueChart.rightAxis.valueFormatter = self
		incomesValueChart.chartDescription?.text = "Income by month"
		incomesValueChart.notifyDataSetChanged()
	}
	
	private func populateInvestmentValueChart(_ incomes: [Income]) {
		var dataEntries: [ChartDataEntry] = []
		
		for income in incomes {
			dataEntries.append(ChartDataEntry(x: income.date.timeIntervalSince1970, y: income.value / income.quantity))
		}
		
		let chartDataSet = LineChartDataSet(values: dataEntries, label: "Investment value")
		let chartData = LineChartData(dataSet: chartDataSet)
		chartData.setValueFormatter(self)
		investmentValueChart.data = chartData
		investmentValueChart.xAxis.valueFormatter = self
		investmentValueChart.leftAxis.valueFormatter = self
		investmentValueChart.rightAxis.valueFormatter = self
		investmentValueChart.chartDescription?.text = "Investment value by month"
		investmentValueChart.notifyDataSetChanged()
	}
	
	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		switch axis {
		case is XAxis:
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MM/YY"
			return dateFormatter.string(from: Date(timeIntervalSince1970: value))
		case is YAxis:
			return "R$\(value)"
		default:
			print("unknown axis")
			return ""
		}
	}
	
	func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
		return "R$\(String(format:"%.2f", value))"
	}
}
