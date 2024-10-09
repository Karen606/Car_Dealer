//
//  CarModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import Foundation

struct CarModel {
    var brand: String?
    var model: String?
    var year: String?
    var mileag: String?
    var purchasePrice: Double?
    var info: String?
    var photoBefore: [Data]?
    var photoAfter: [Data]?
    var expenses: [ExpensesModel]?
    var isSold: Bool = false
    var id: UUID
    var salePrice: Double?
}

struct ExpensesModel {
    var name: String?
    var price: Double?
}
