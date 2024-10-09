//
//  Font.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

extension UIFont {
    static func regular(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular", size: CGFloat(size))
    }
    
    static func medium(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Medium", size: CGFloat(size))
    }
    
    static func semibold(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-SemiBold", size: CGFloat(size))
    }
    
    static func bold(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Bold", size: CGFloat(size))
    }
    
    static func proMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "gothampro_medium", size: CGFloat(size))
    }
}
