//
//  ReportsViewModel.swift
//  Car_Dealer
//
//  Created by Karen Khachatryan on 10.10.24.
//

import Foundation

class ReportsViewModel {
    static let shared = ReportsViewModel()
    @Published var reportsModel = ReportsModel(sold: 0, income: 0, expenditure: 0)
    private var cars: [CarModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchMyCars { [weak self] cars, error in
            guard let self = self else { return }
            self.cars = cars
            filter()
        }
    }
    
    func filter() {
        if self.reportsModel.isAllPeriod {
            fetchAllPeriod()
        } else {
            filterReportsByPeriod()
        }
    }
    
    func filterReportsByPeriod() {
        
        let calendar = Calendar.current
        
        // Normalize dates to remove time component
        let startDate = reportsModel.startDate
        
        let endOfDay = reportsModel.endDate
        
        // Filter cars by soldDate within the date range
        let filteredCarsBySoldDate = cars.filter { car in
            if let soldDate = car.soldDate {
                let normalizedSoldDate = calendar.startOfDay(for: soldDate)
                return normalizedSoldDate >= startDate && normalizedSoldDate < endOfDay
            }
            return false
        }
        
        // Calculate totalSold by date range soldDate
        let totalSold = filteredCarsBySoldDate.reduce(0.0) { (total, car) -> Double in
            total + (car.salePrice ?? 0.0)
        }
        
        // Calculate totalExpenses by date range ExpensesModel date
        let totalExpenses = cars.reduce(0.0) { (total, car) -> Double in
            total + (car.expenses?.filter { expense in
                if let expenseDate = expense.date {
                    let normalizedExpenseDate = calendar.startOfDay(for: expenseDate)
                    return normalizedExpenseDate >= startDate && normalizedExpenseDate < endOfDay
                }
                return false
            }.reduce(0.0) { (expensesTotal, expense) -> Double in
                expensesTotal + (expense.price ?? 0.0)
            } ?? 0.0)
        }
        
        // Filter cars by purchaseDate within the date range
        let filteredCarsByPurchaseDate = cars.filter { car in
            if let purchaseDate = car.purchaseDate {
                let normalizedPurchaseDate = calendar.startOfDay(for: purchaseDate)
                return normalizedPurchaseDate >= startDate && normalizedPurchaseDate < endOfDay
            }
            return false
        }
        
        // Calculate totalPurchases by date range purchaseDate
        let totalPurchases = filteredCarsByPurchaseDate.reduce(0.0) { (total, car) -> Double in
            total + (car.purchasePrice ?? 0.0)
        }
        let totalExpenditure = totalExpenses + totalPurchases
        let totalIncome = totalSold - totalExpenditure
        
        self.reportsModel.sold = totalSold
        self.reportsModel.income = totalIncome
        self.reportsModel.expenditure = totalExpenditure
    }
    
    func fetchAllPeriod() {
        let totalSold = cars.reduce(0.0) { (total, car) -> Double in
            total + (car.salePrice ?? 0.0)
        }
        
        let totalExpenses = cars.reduce(0.0) { (total, car) -> Double in
            total + (car.expenses?.reduce(0.0) { (expensesTotal, expense) -> Double in
                expensesTotal + (expense.price ?? 0.0)
            } ?? 0.0)
        }
        
        let totalPurchases = cars.reduce(0.0) { (total, car) -> Double in
            total + (car.purchasePrice ?? 0.0)
        }
        
        let totalExpenditure = totalExpenses + totalPurchases
        let totalIncome = totalSold - totalExpenditure
        
        self.reportsModel.sold = totalSold
        self.reportsModel.income = totalIncome
        self.reportsModel.expenditure = totalExpenditure
    }
    
}
