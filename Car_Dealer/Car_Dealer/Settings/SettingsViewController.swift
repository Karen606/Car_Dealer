//
//  SettingsViewController.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 10.10.24.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var sectionButtons: [UIButton]!
    @IBOutlet var sectionsView: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionButtons.forEach({ $0.titleLabel?.font = .semibold(size: 22) })
        setNavigationBar(title: "Help")
    }
}
