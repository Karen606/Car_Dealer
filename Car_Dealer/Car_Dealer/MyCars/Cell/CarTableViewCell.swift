//
//  CarTableViewCell.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

protocol CarTableViewCellDelegate: AnyObject {
    func showError(error: Error)
}

class CarTableViewCell: UITableViewCell {
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var purchaseLabel: UILabel!
    @IBOutlet weak var expansesLabel: UILabel!
    @IBOutlet weak var soldPriceLabel: UILabel!
    @IBOutlet weak var soldTitleLabel: UILabel!
    @IBOutlet weak var purchaseTitleLabel: UILabel!
    @IBOutlet weak var expensesTitleLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var removeButton: UIButton!
    weak var delegate: CarTableViewCellDelegate?
    var carID: UUID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labels.forEach({ $0.font = .regular(size: 18) })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupContent(carModel: CarModel) {
        self.carID = carModel.id
        modelLabel.text = "\(carModel.brand ?? "") \(carModel.model ?? "")"
        yearLabel.text = carModel.year
        mileageLabel.text = "\(carModel.mileag ?? "") km"
        purchaseLabel.text = "\(carModel.purchasePrice.formattedToString())$"
        let expenses = carModel.expenses?.reduce(0.0) { (result, expense) -> Double in
            result + (expense.price ?? 0.0)
        }       
        expansesLabel.text = "\(expenses.formattedToString())$"
        if carModel.isSold {
            soldPriceLabel.isHidden = false
            soldTitleLabel.isHidden = false
            soldPriceLabel.text = "\(carModel.salePrice.formattedToString())$"
        } else {
            soldPriceLabel.isHidden = true
            soldTitleLabel.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        self.carID = nil
    }
    
    @IBAction func clickedRemove(_ sender: UIButton) {
        guard let id = carID else { return }
        MyCarsViewModel.shared.removeCar(id: id) { [weak self] error in
            guard let self = self, let error = error else { return }
            delegate?.showError(error: error)
        }
    }
}
