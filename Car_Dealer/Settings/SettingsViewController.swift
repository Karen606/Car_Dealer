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
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeVC = MFMailComposeViewController()
//            mailComposeVC.mailComposeDelegate = self
//            mailComposeVC.setToRecipients(["alina.sverlova6@icloud.com"])
//            present(mailComposeVC, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(
//                title: "Mail Not Available",
//                message: "Please configure a Mail account in your settings.",
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        }
    }
//
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
//        let privacyVC = PrivacyViewController()
//        privacyVC.url = URL(string: "https://docs.google.com/document/d/1p_yBtClAhyrHDqzp_F3CzFggKrz-a5PItc2JKsjXrhU/mobilebasic")
//        self.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(privacyVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
    }
//
    @IBAction func clickedRateUs(_ sender: UIButton) {
//        let appID = "6742742223"
//        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                print("Unable to open App Store URL")
//            }
//        }
    }
}

//
//extension SettingsViewController: MFMailComposeViewControllerDelegate {
//    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}

