//
//  Double.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import Foundation

extension Double? {
    func formattedToString() -> String {
        guard let self = self else { return "" }
        if Double(Int(self)) == self {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }
}
