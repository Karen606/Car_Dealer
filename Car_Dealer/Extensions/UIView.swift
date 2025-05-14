//
//  UIView.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow(color: UIColor = UIColor.black.withAlphaComponent(0.25),
                   offset: CGSize = CGSize(width: 0, height: 4),
                   radius: CGFloat = 4,
                   opacity: Float = 1.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func addBottomBorder(color: UIColor, thickness: CGFloat) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
        bottomBorder.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomBorder)
    }
    
    func setGradientBackground() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.6106664538, green: 0.6106664538, blue: 0.6106664538, alpha: 1).withAlphaComponent(0.54).cgColor, UIColor.white.cgColor]
        gradientLayer.cornerRadius = 8
//        gradientLayer.locations = [0.1476, 1.0]
        gradientLayer.locations = [0.0, 0.7, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
