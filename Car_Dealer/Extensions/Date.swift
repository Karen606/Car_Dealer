//
//  Date.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 10.10.24.
//

import Foundation

extension Date {
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }

    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }

    func endOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: self.startOfDay())!.addingTimeInterval(-1)
    }
    
    func toString(format: String = "dd/MM/yyyy") -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: self)
        }
}
