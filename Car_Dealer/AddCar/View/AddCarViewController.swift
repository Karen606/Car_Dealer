//
//  AddCarViewController.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit
import Combine

class AddCarViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var carBrandTextField: BaseTextField!
    @IBOutlet weak var carModelTextField: BaseTextField!
    @IBOutlet weak var yearTextField: BaseTextField!
    @IBOutlet weak var milTextField: BaseTextField!
    @IBOutlet weak var priceTextField: PricesTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: BaseButton!
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel = AddCarViewModel.shared
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }

    func setupUI() {
        self.registerKeyboardNotifications()
        setNavigationBar(title: "Add a car")
        saveButton.titleLabel?.font = .regular(size: 19.5)
        descriptionTextView.font = .regular(size: 14)
        descriptionTextView.addShadow()
        let textFields = [carBrandTextField, carModelTextField, yearTextField, milTextField]
        textFields.forEach({ $0?.delegate = self })
        descriptionTextView.delegate = self
        priceTextField.baseDelegate = self
    }
    
    func subscribe() {
        viewModel.$carModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] carModel in
                guard let self = self else { return }
                self.saveButton.isEnabled = self.viewModel.isValid()
            }
            .store(in: &cancellables)
    }

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.handleTap()
    }
    
    @IBAction func clickedSaveButton(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddCarViewController: PriceTextFielddDelegate, UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let value = textField.text else { return }
        switch textField {
        case priceTextField:
            viewModel.carModel.purchasePrice = priceTextField.formatNumber()
        case carBrandTextField:
            viewModel.carModel.brand = value
        case carModelTextField:
            viewModel.carModel.model = value
        case yearTextField:
            viewModel.carModel.year = value
        case milTextField:
            viewModel.carModel.mileag = value
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
        } else if textField == yearTextField || textField == milTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.carModel.info = textView.text
    }
}

extension AddCarViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(AddCarViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
