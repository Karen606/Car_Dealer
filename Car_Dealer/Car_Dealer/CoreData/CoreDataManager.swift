//
//  CoreDataManager.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 09.10.24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Car_Dealer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
//    func fetchWine(completion: @escaping ([WineModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Wine> = Wine.fetchRequest()
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var wineModels: [WineModel] = []
//                for result in results {
//                    let wineModel = WineModel(id: result.id ?? UUID(), name: result.name, photo: result.photo, grape: result.grape, country: result.country, year: result.year, qualities: result.qualities, rating: result.rating, isFavorite: result.isFavorite, isMyWine: result.isMyWine)
//                    wineModels.append(wineModel)
//                }
//                DispatchQueue.main.async {
//                    completion(wineModels, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
//    
//    func fetchFavoriteWine(completion: @escaping ([WineModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Wine> = Wine.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var wineModels: [WineModel] = []
//                for result in results {
//                    let wineModel = WineModel(id: result.id ?? UUID(),
//                                              name: result.name,
//                                              photo: result.photo,
//                                              grape: result.grape,
//                                              country: result.country,
//                                              year: result.year,
//                                              qualities: result.qualities,
//                                              rating: result.rating,
//                                              isFavorite: result.isFavorite,
//                                              isMyWine: result.isMyWine)
//                    wineModels.append(wineModel)
//                }
//                DispatchQueue.main.async {
//                    completion(wineModels, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
//    
    func fetchMyCars(completion: @escaping ([CarModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var carModels: [CarModel] = []
                for result in results {
                    let carModel = CarModel(brand: result.brand, model: result.model, year: result.year, mileag: result.mileag, purchasePrice: result.purchasePrice, info: result.info, photoBefore: result.photoBefore, photoAfter: result.photoAfter, expenses: Array(_immutableCocoaArray: result.expenses ?? []), isSold: result.isSold, id: result.id ?? UUID(), salePrice: result.salePrice)
                    carModels.append(carModel)
                }
                DispatchQueue.main.async {
                    completion(carModels, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func saveWine(carModel: CarModel, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", carModel.id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let car: Car

                if let existingCar = results.first {
                    car = existingCar
                } else {
                    car = Car(context: backgroundContext)
                    car.id = carModel.id
                }
                car.brand = carModel.brand
                car.expenses = NSOrderedSet(array: carModel.expenses ?? [])
                car.info = carModel.info
                car.isSold = carModel.isSold
                car.mileag = carModel.mileag
                car.model = carModel.mileag
                car.purchasePrice = carModel.purchasePrice ?? 0
                car.salePrice = carModel.salePrice ?? 0
                car.year = carModel.year
                car.photoBefore = carModel.photoBefore
                car.photoAfter = carModel.photoAfter
    
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func saleCar(carModel: CarModel, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", carModel.id as CVarArg)
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                
                if let car = results.first {
                    car.isSold = true
                    car.brand = carModel.brand
                    car.expenses = NSOrderedSet(array: carModel.expenses ?? [])
                    car.info = carModel.info
                    car.mileag = carModel.mileag
                    car.model = carModel.mileag
                    car.purchasePrice = carModel.purchasePrice ?? 0
                    car.salePrice = carModel.salePrice ?? 0
                    car.year = carModel.year
                    car.photoBefore = carModel.photoBefore
                    car.photoAfter = carModel.photoAfter
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Wine not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
//
//    func updateMyWineStatus(wineID: UUID, isMyWine: Bool, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Wine> = Wine.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", wineID as CVarArg)
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                
//                if let wine = results.first {
//                    wine.isMyWine = isMyWine
//                    try backgroundContext.save()
//                    DispatchQueue.main.async {
//                        completion(nil)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Wine not found"]))
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
}
