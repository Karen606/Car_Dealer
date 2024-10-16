//
//  CarModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit


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
    var purchaseDate: Date?
    var soldDate: Date?
}

struct ExpensesModel {
    var name: String?
    var price: Double?
    var date: Date?
}
