//
//  MyCarsViewController.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit
import Combine

class MyCarsViewController: UIViewController {

    @IBOutlet weak var addCarButton: UIButton!
    @IBOutlet weak var carTableView: UITableView!
    private let viewModel = MyCarsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationBar(title: "My cars")
        addCarButton.titleLabel?.font = .semibold(size: 20)
        carTableView.delegate = self
        carTableView.dataSource = self
        carTableView.register(UINib(nibName: "CarTableViewCell", bundle: nil), forCellReuseIdentifier: "CarTableViewCell")
    }
    
    func subscribe() {
        viewModel.$cars
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cars in
                guard let self = self else { return }
                self.carTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func clickedSale(sender: UIButton) {
        let saleCarVC = SaleCarViewController(nibName: "SaleCarViewController", bundle: nil)
        saleCarVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        SaleCarViewModel.shared.carModel = viewModel.cars[sender.tag]
        self.navigationController?.pushViewController(saleCarVC, animated: true)
    }

    @IBAction func clickedAddCar(_ sender: UIButton) {
        let addCarVC = AddCarViewController(nibName: "AddCarViewController", bundle: nil)
        addCarVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        self.navigationController?.pushViewController(addCarVC, animated: true)
    }
}

extension MyCarsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.cars.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: indexPath) as! CarTableViewCell
        cell.setupContent(carModel: viewModel.cars[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.cars[section].isSold {
            return UIView()
        } else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            let button = UIButton(type: .custom)
            button.backgroundColor = .black
            button.setTitle("Sale", for: .normal)
            button.titleLabel?.font = .regular(size: 15)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(clickedSale(sender:)), for: .touchUpInside)
            button.tag = section
            button.frame = CGRect(x: (footerView.frame.width - 126) / 2, y: (footerView.frame.height - 25) / 2, width: 126, height: 25)
            button.layer.cornerRadius = 2.5
            footerView.addSubview(button)
            return footerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.cars[section].isSold ? 8 : 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let carVC = CarViewController(nibName: "CarViewController", bundle: nil)
        carVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        CarViewModel.shared.car = viewModel.cars[indexPath.section]
        self.navigationController?.pushViewController(carVC, animated: true)
    }
}
