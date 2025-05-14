//
//  ShadowView.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

class ShadowView: UIView {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        addShadow()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         addShadow()
     }
}

class GradientView: UIView {
    override init(frame: CGRect) {
         super.init(frame: frame)
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientBackground()
    }
}
