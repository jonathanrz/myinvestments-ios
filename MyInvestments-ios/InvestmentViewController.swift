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
					self.populateIncomeValueChart(incomes: incomes)
					self.populateInvestmentValueChart(incomes: incomes)
				} else {
					print(error!)
				}
			})
		} catch {
			print("Couldn't initialize server, possible missing of keys.plist")
		}
	}
	
	private func populateIncomeValueChart(incomes: [Income]) {
		var dataEntries: [ChartDataEntry] = []
		
		let incomesSorted = incomes.sorted(by: { $0.date.compare($1.date) == ComparisonResult.orderedAscending })
		for income in incomesSorted {
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
	}
	
	private func populateInvestmentValueChart(incomes: [Income]) {
		var dataEntries: [ChartDataEntry] = []
		
		let incomesSorted = incomes.sorted(by: { $0.date.compare($1.date) == ComparisonResult.orderedAscending })
		for income in incomesSorted {
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
