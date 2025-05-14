//
//  ReportsViewController.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 10.10.24.
//

import UIKit
import Combine

class ReportsViewController: UIViewController {
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var selectedPeriodLabel: UILabel!
    @IBOutlet weak var startPeriodTextView: UITextView!
    @IBOutlet weak var endPeriodTextView: UITextView!
    @IBOutlet weak var soldLabel: UILabel!
    @IBOutlet var periodsView: [UIView]!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenditureLabel: UILabel!
    @IBOutlet weak var startPeriodArrow: UIImageView!
    @IBOutlet weak var endPeriodArrow: UIImageView!
    @IBOutlet weak var allPeriodSwitcher: UISwitch!
    @IBOutlet var calendarImageViews: [UIImageView]!
    private let viewModel = ReportsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationBar(title: "Statistics")
        labels.forEach({ $0.font = .medium(size: 20) })
        selectedPeriodLabel.font = .medium(size: 13)
        startPeriodTextView.font = .regular(size: 14)
        endPeriodTextView.font = .regular(size: 14)
        periodsView.forEach { view in
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        }
        startDatePicker.locale = NSLocale.current
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .inline
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged(sender:)), for: .valueChanged)
        endDatePicker.locale = NSLocale.current
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .inline
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged(sender:)), for: .valueChanged)
        startPeriodTextView.inputView = startDatePicker
        endPeriodTextView.inputView = endDatePicker
//        periodView.addShadow()
    }
    
    func subscribe() {
        viewModel.$reportsModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] report in
                guard let self = self else { return }
                self.allPeriodSwitcher.isOn = report.isAllPeriod
                self.startPeriodTextView.text = report.startDate.toString()
                self.endPeriodTextView.text = report.endDate.toString()
                self.incomeLabel.text = "Income\n\(report.income.formattedToString())$"
                self.soldLabel.text = "Sold\n\(report.sold.formattedToString())$"
                self.expenditureLabel.text = "Expenditure\n\(report.expenditure.formattedToString())$"
                self.updateUI()
            }
            .store(in: &cancellables)
    }
    
    func updateUI() {
        if viewModel.reportsModel.isAllPeriod {
            periodsView.forEach({ $0.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor })
            calendarImageViews.forEach({ $0.isHighlighted = false })
            startPeriodTextView.textColor = .black.withAlphaComponent(0.2)
            endPeriodTextView.textColor = .black.withAlphaComponent(0.2)
            startPeriodArrow.isHighlighted = false
            endPeriodArrow.isHighlighted = false
        } else {
            periodsView.forEach({ $0.layer.borderColor = UIColor.black.cgColor })
            calendarImageViews.forEach({ $0.isHighlighted = true })
            startPeriodTextView.textColor = .black
            endPeriodTextView.textColor = .black
            startPeriodArrow.isHighlighted = true
            endPeriodArrow.isHighlighted = true
        }
        startPeriodTextView.isSelectable = !viewModel.reportsModel.isAllPeriod
        endPeriodTextView.isSelectable = !viewModel.reportsModel.isAllPeriod
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @objc func startDatePickerValueChanged(sender: UIDatePicker) {
        viewModel.reportsModel.startDate = sender.date
        self.view.endEditing(true)
        viewModel.filter()
    }
    
    @objc func endDatePickerValueChanged(sender: UIDatePicker) {
        viewModel.reportsModel.endDate = sender.date
        self.view.endEditing(true)
        viewModel.filter()
    }
    
    @IBAction func clickedAllPeriod(_ sender: UISwitch) {
        viewModel.reportsModel.isAllPeriod = sender.isOn
        viewModel.filter()
    }
}
