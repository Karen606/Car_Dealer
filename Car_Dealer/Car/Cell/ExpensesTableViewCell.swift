//
//  ExpensesTableViewCell.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 10.10.24.
//

import UIKit

class ExpensesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: BasePriceTextField!
    private var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.font = .regular(size: 16)
        priceTextField.font = .regular(size: 16)
        nameTextField.delegate = self
        priceTextField.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        index = 0
    }
    
    func setupContent(expense: ExpensesModel?, index: Int) {
        nameTextField.text = expense?.name
        if expense?.price != nil {
            priceTextField.text = "\(expense?.price.formattedToString() ?? "")$"
        } else {
            priceTextField.text = nil
        }
        self.index = index
    }
}

extension ExpensesTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let value = textField.text else { return }
        switch textField {
        case priceTextField:
            CarViewModel.shared.car?.expenses?[index].price = Double(value)
        case nameTextField:
            CarViewModel.shared.car?.expenses?[index].name = value
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == priceTextField, let value = textField.text, !value.isEmpty {
            priceTextField.text! += "$"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == priceTextField, let value = textField.text, !value.isEmpty && value.last == "$" {
            priceTextField.text?.removeLast()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceTextField {
            return priceTextField.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
    }
    
}
