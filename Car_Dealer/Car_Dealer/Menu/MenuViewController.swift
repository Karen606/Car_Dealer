//
//  ViewController.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var sectionButtons: [UIButton]!
    @IBOutlet var sectionsView: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionButtons.forEach({ $0.titleLabel?.font = .semibold(size: 22) })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func clickedMyCars(_ sender: UIButton) {
        let myCarsVC = MyCarsViewController(nibName: "MyCarsViewController", bundle: nil)
        self.navigationController?.pushViewController(myCarsVC, animated: true)
    }
    
    @IBAction func clickedAddCar(_ sender: UIButton) {
        let addCarVC = AddCarViewController(nibName: "AddCarViewController", bundle: nil)
        self.navigationController?.pushViewController(addCarVC, animated: true)    }
    
    @IBAction func clickedReports(_ sender: UIButton) {
        self.pushViewController(ReportsViewController.self)
    }
    
    @IBAction func clickedHelp(_ sender: UIButton) {
        self.pushViewController(SettingsViewController.self)
    }
}

