//
//  CarViewController.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 10.10.24.
//

import UIKit
import FSPagerView
import PhotosUI
import Combine

class CarViewController: UIViewController {

    @IBOutlet weak var beforePagerView: FSPagerView!
    @IBOutlet weak var beforePageControl: FSPageControl!
    @IBOutlet weak var afterPagerView: FSPagerView!
    @IBOutlet weak var afterPageControll: FSPageControl!
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var purchasesPriceLabel: UILabel!
    @IBOutlet weak var soldPriceLabel: UILabel!
    @IBOutlet weak var soldTitleLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    private let addExpenseButton = UIButton()
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var saveButton: BaseButton!
    private var itemSize: CGFloat = .zero
    private var isInitial = false
    private let viewModel = CarViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagerView()
        setupUI()
        subscribe()
    }
    
    func setupPagerView() {
        beforePagerView.dataSource = self
        beforePagerView.delegate = self
        beforePagerView.contentMode = .center
        beforePagerView.transformer = FSPagerViewTransformer(type: .linear)
        beforePagerView.itemSize = CGSize(width: 40, height: 40)
        beforePagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        beforePagerView.addShadow()
        
        afterPagerView.dataSource = self
        afterPagerView.delegate = self
        afterPagerView.contentMode = .center
        afterPagerView.transformer = FSPagerViewTransformer(type: .linear)
        afterPagerView.itemSize = CGSize(width: 40, height: 40)
        afterPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        afterPagerView.addShadow()
        
        beforePageControl.contentHorizontalAlignment = .center
        beforePageControl.setStrokeColor(.white, for: .normal)
        beforePageControl.setFillColor(.darkGray, for: .selected)
        beforePageControl.setFillColor(.lightGray, for: .normal)
        afterPageControll.contentHorizontalAlignment = .center
        afterPageControll.setStrokeColor(.white, for: .normal)
        afterPageControll.setFillColor(.darkGray, for: .selected)
        afterPageControll.setFillColor(.lightGray, for: .normal)
    }
    
    func setupUI() {
        setNavigationBar(title: "")
        labels.forEach({ $0.font = .regular(size: 18) })
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
        expensesTableView.register(UINib(nibName: "ExpensesTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpensesTableViewCell")
    }
    
    func subscribe() {
        viewModel.$car
            .receive(on: DispatchQueue.main)
            .sink { [weak self] car in
                guard let self = self else { return }
                if !self.isInitial {
                    self.isInitial = true
                    self.setNavigationBar(title: car?.model ?? "")
                    self.modelLabel.text = car?.model
                    self.yearLabel.text = car?.year
                    self.mileageLabel.text = car?.mileag
                    self.purchasesPriceLabel.text = "\(car?.purchasePrice.formattedToString() ?? "")$"
                    if car?.isSold ?? false {
                        self.soldTitleLabel.isHidden = false
                        self.soldPriceLabel.isHidden = false
                        self.soldPriceLabel.text = "\(car?.salePrice.formattedToString() ?? "")$"
                    } else {
                        self.soldTitleLabel.isHidden = true
                        self.soldPriceLabel.isHidden = true
                    }
                }
                let beforeSize = (self.viewModel.isAppenedBefore || car?.photoBefore?.count ?? 0 > 1) ? self.beforePagerView.bounds.size : CGSize(width: 40, height: 40)
                let afterSize = (self.viewModel.isAppenedAfter || car?.photoAfter?.count ?? 0 > 1) ? self.afterPagerView.bounds.size : CGSize(width: 40, height: 40)
                self.beforePagerView.itemSize = beforeSize
                self.afterPagerView.itemSize = afterSize
                self.beforePagerView.reloadData()
                self.afterPagerView.reloadData()
                self.beforePageControl.numberOfPages = car?.photoBefore?.count ?? 0
                self.afterPageControll.numberOfPages = car?.photoAfter?.count ?? 0
                if (car?.expenses?.count ?? 0) != viewModel.oldExpensesCount {
                    self.expensesTableView.reloadData()
                    viewModel.oldExpensesCount = car?.expenses?.count ?? 0
                }
                let expenses = car?.expenses?.reduce(0.0) { (result, expense) -> Double in
                    result + (expense.price ?? 0.0)
                }
                self.totalExpensesLabel.text = "\(expenses.formattedToString())$"
                let isValid = self.viewModel.isValid()
                self.addExpenseButton.isEnabled = isValid
                self.saveButton.isEnabled = isValid
            }
            .store(in: &cancellables)
    }
    
    func choosePhoto(tag: Int) {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.requestCameraAccess(tag: tag)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.requestPhotoLibraryAccess(tag: tag)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view // Your source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func addexpense() {
        viewModel.car?.expenses?.append(ExpensesModel())
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
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
    
    deinit {
        viewModel.clear()
    }
}

extension CarViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == beforePagerView {
            return viewModel.car?.photoBefore?.count ?? 0
        }
        return viewModel.car?.photoAfter?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if pagerView == beforePagerView {
            if let data = viewModel.car?.photoBefore?[index] {
                cell.imageView?.image = UIImage(data: data)
            }
        } else {
            if let data = viewModel.car?.photoAfter?[index] {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let tag = pagerView == beforePagerView ? 2 : 3
        choosePhoto(tag: tag)
    }
        
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let currentPage = pagerView.currentIndex
        if pagerView == beforePagerView {
            beforePageControl.currentPage = currentPage
        } else {
            afterPageControll.currentPage = currentPage
        }
    }
}


extension CarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func requestCameraAccess(tag: Int) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera(tag: tag)
                }
            }
        case .authorized:
            openCamera(tag: tag)
        case .denied, .restricted:
            showSettingsAlert()
        @unknown default:
            break
        }
    }
    
    private func requestPhotoLibraryAccess(tag: Int) {
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        switch photoStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard let self = self else { return }
                if status == .authorized {
                    self.openPhotoLibrary(tag: tag)
                }
            }
        case .authorized:
            openPhotoLibrary(tag: tag)
        case .denied, .restricted:
            showSettingsAlert()
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    private func openCamera(tag: Int) {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.view.tag = tag
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func openPhotoLibrary(tag: Int) {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.view.tag = tag
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "Access Needed", message: "Please allow access in Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            image = originalImage
        }
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            let data = imageData as Data
            if picker.view.tag == 2 {
                viewModel.addBeforeImage(data: data)
            } else if picker.view.tag == 3 {
                viewModel.addAfterImage(data: data)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.car?.expenses?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTableViewCell", for: indexPath) as! ExpensesTableViewCell
        if !(viewModel.car?.expenses?.isEmpty ?? true) {
            cell.setupContent(expense: viewModel.car?.expenses?[indexPath.row], index: indexPath.row)
        } else {
            cell.setupContent(expense: nil, index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 76))
        addExpenseButton.setImage(UIImage.addBlue, for: .normal)
        addExpenseButton.addTarget(self, action: #selector(addexpense), for: .touchUpInside)
        addExpenseButton.frame = CGRect(x: (footerView.frame.width - 38) / 2, y: (footerView.frame.height - 38) / 2, width: 38, height: 38)
        footerView.addSubview(addExpenseButton)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        76
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        42
    }
}
