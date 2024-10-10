//
//  AddCarViewModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import UIKit

class AddCarViewModel {
    static let shared = AddCarViewModel()
    @Published var carModel = CarModel(photoBefore: [UIImage.imagePlaceholder.jpegData(compressionQuality: 1.0) ?? Data()], photoAfter: [UIImage.imagePlaceholder.jpegData(compressionQuality: 1.0) ?? Data()], id: UUID(), purchaseDate: Date())
    
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveCar(carModel: carModel) { error in
            completion(error)
        }
    }
    
    func isValid() -> Bool {
        return carModel.brand.checkValidation() && carModel.info.checkValidation() && carModel.mileag.checkValidation() && carModel.model.checkValidation() && carModel.purchasePrice != nil && carModel.year.checkValidation()
    }
    
    func clear() {
        carModel = CarModel(photoBefore: [UIImage.imagePlaceholder.jpegData(compressionQuality: 1.0) ?? Data()], photoAfter: [UIImage.imagePlaceholder.jpegData(compressionQuality: 1.0) ?? Data()], expenses: [ExpensesModel()], id: UUID(), purchaseDate: Date())
    }
}
