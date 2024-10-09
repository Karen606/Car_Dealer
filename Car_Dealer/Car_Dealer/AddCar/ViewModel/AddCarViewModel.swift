//
//  AddCarViewModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import Foundation

class AddCarViewModel {
    static let shared = AddCarViewModel()
    @Published var carModel = CarModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveWine(carModel: carModel) { error in
            completion(error)
        }
    }
    
    func isValid() -> Bool {
        return carModel.brand.checkValidation() && carModel.info.checkValidation() && carModel.mileag.checkValidation() && carModel.model.checkValidation() && carModel.purchasePrice != nil && carModel.year.checkValidation()
    }
    
    func clear() {
        carModel = CarModel(id: UUID())
    }
}
