//
//  MyCarsViewModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import Foundation

class MyCarsViewModel {
    static let shared = MyCarsViewModel()
    @Published var cars: [CarModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchMyCars { [weak self] carsModel, error in
            guard let self = self else { return }
            self.cars = carsModel
        }
    }
    
    func sale() {
        
    }
}
