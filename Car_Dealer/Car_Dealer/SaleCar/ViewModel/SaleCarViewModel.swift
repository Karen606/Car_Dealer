//
//  SaleCarViewModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import Foundation

class SaleCarViewModel {
    static let shared = SaleCarViewModel()
    @Published var carModel: CarModel?
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        guard let carModel = carModel else { return }
        CoreDataManager.shared.saleCar(carModel: carModel) { error in
            completion(error)
        }
    }
    
    func isValid() -> Bool {
        guard let carModel = carModel else { return false }
        return carModel.brand.checkValidation() && carModel.info.checkValidation() && carModel.mileag.checkValidation() && carModel.model.checkValidation() && carModel.purchasePrice != nil && carModel.year.checkValidation() && (carModel.salePrice ?? 0 > 0)
    }
    
    func clear() {
        carModel = nil
    }
}
