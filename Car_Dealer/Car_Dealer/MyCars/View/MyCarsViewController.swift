//
//  MyCarsViewController.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

class MyCarsViewController: UIViewController {

    @IBOutlet weak var addCarButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setNavigationBar(title: "My cars")
        addCarButton.titleLabel?.font = .semibold(size: 20)
    }

    @IBAction func clickedAddCar(_ sender: UIButton) {
        self.pushViewController(AddCarViewController.self)
    }
}
