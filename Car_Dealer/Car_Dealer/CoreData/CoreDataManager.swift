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
    
    func fetchMyCars(completion: @escaping ([CarModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var carModels: [CarModel] = []
                for result in results {
                    var expensesModel: [ExpensesModel] = []
                    if let expenses = result.expenses as? Set<Expenses> {
                        for expense in expenses {
                            let price = expense.price == 0 ? nil : expense.price
                            let expenseModel = ExpensesModel(name: expense.name, price: price)
                            expensesModel.append(expenseModel)
                        }
                    }
                    let carModel = CarModel(brand: result.brand, model: result.model, year: result.year, mileag: result.mileag, purchasePrice: result.purchasePrice, info: result.info, photoBefore: result.photoBefore, photoAfter: result.photoAfter, expenses: expensesModel, isSold: result.isSold, id: result.id ?? UUID(), salePrice: result.salePrice)
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
    
    func saveCar(carModel: CarModel, completion: @escaping (Error?) -> Void) {
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
                car.info = carModel.info
                car.isSold = carModel.isSold
                car.mileag = carModel.mileag
                car.model = carModel.model
                car.purchasePrice = carModel.purchasePrice ?? 0
                car.salePrice = carModel.salePrice ?? 0
                car.year = carModel.year
                car.photoBefore = carModel.photoBefore
                car.photoAfter = carModel.photoAfter
                
                if let expenses = carModel.expenses {
                    var carExpenses = Set<Expenses>()
                    for expenseModel in expenses {
                        let carExpense = Expenses(context: backgroundContext)
                        carExpense.name = expenseModel.name
                        carExpense.price = expenseModel.price ?? 0
                        carExpenses.insert(carExpense)
                    }
                    car.expenses = carExpenses as NSSet
                } else {
                    car.expenses = nil
                }
                
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
                    car.info = carModel.info
                    car.mileag = carModel.mileag
                    car.model = carModel.model
                    car.purchasePrice = carModel.purchasePrice ?? 0
                    car.salePrice = carModel.salePrice ?? 0
                    car.year = carModel.year
                    car.photoBefore = carModel.photoBefore
                    car.photoAfter = carModel.photoAfter
                    if let expenses = carModel.expenses {
                        var carExpenses = Set<Expenses>()
                        for expenseModel in expenses {
                            let carExpense = Expenses(context: backgroundContext)
                            carExpense.name = expenseModel.name
                            carExpense.price = expenseModel.price ?? 0
                            carExpenses.insert(carExpense)
                        }
                        car.expenses = carExpenses as NSSet
                    } else {
                        car.expenses = nil
                    }
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
    
    func removeCar(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let carToDelete = results.first {
                    backgroundContext.delete(carToDelete)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "removeCar", code: 404, userInfo: [NSLocalizedDescriptionKey: "Car not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

}
