//
//  ReportsModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 10.10.24.
//

import Foundation

struct ReportsModel {
    var startDate = Date().startOfMonth()
    var endDate = Date().endOfDay()
    var isAllPeriod = false
    var sold: Double
    var income: Double
    var expenditure: Double
}
