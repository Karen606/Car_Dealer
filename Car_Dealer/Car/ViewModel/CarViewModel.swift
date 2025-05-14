//
//  CarViewModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 10.10.24.
//

import Foundation

class CarViewModel {
    static let shared = CarViewModel()
    @Published var car: CarModel?
    var isAppenedBefore = false
    var isAppenedAfter = false
    var oldExpensesCount: Int = 0

    func addBeforeImage(data: Data) {
        if !isAppenedBefore {
            car?.photoBefore?.removeAll()
            isAppenedBefore = true
        }
        car?.photoBefore?.append(data)
    }
    
    func addAfterImage(data: Data) {
        if !isAppenedAfter {
            car?.photoAfter?.removeAll()
            isAppenedAfter = true
        }
        car?.photoAfter?.append(data)
    }
    
    func isValid() -> Bool {
        guard let expenses = car?.expenses else { return false }
        return !(expenses.contains(where: { (!$0.name.checkValidation() && ($0.price != nil && $0.price != 0)) || ($0.name.checkValidation() && ($0.price == nil || $0.price == 0))}))
    }
    
    func save(completion: @escaping (Error?) -> Void) {
        self.car?.expenses?.removeAll(where: { !$0.name.checkValidation() })
        guard let car = car else { return }
        CoreDataManager.shared.saveCar(carModel: car) { error in
            completion(error)
        }
    }
    
    func clear() {
        car = nil
        isAppenedBefore = false
        isAppenedAfter = false
        oldExpensesCount = 0
    }
    
    private init() {}
}
