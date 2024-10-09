//
//  ViewController.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func clickedMyCars(_ sender: UIButton) {
        let myCarsVC = MyCarsViewController(nibName: "MyCarsViewController", bundle: nil)
        self.navigationController?.pushViewController(myCarsVC, animated: true)
    }
    
}

