//
//  TitleLabel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

class TitleLabel: UILabel {
    override init(frame: CGRect) {
         super.init(frame: frame)
        setupFont()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setupFont()
     }
    
    func setupFont() {
        self.font = .regular(size: 14)
        self.textColor = .titleText
    }
}


