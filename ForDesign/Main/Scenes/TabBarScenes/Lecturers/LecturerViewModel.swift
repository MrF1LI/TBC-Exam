//
//  LecturerViewModel.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 05.09.22.
//

import Foundation

struct LecturerViewModel {
    
    private var lecturer: Lecturer
    
    init(lecturer: Lecturer) {
        self.lecturer = lecturer
    }
    
    var id: String { lecturer.id }
    var name: String { lecturer.name }
    var surname: String { lecturer.surname }
    var email: String { lecturer.email }
    var subject: String { lecturer.subject }
    var profile: String { lecturer.profile }
    var rates: [String:Int]? { lecturer.rates }
    var recommended: Bool? { lecturer.recommended }
    
    // MARK: - Functions
    
    func getRating() -> Float {
        guard let rates = rates else { return 0 }

        let arrayOfRates = rates.map { $0.value }
        let rating: Float = Float(arrayOfRates.reduce(0, +)) / Float(arrayOfRates.count)
        
        return rating
    }
    
    func getRatingDetails() -> Lecturer.RateDetails? {
        guard let rates = rates else { return nil }
        
        let arrayOfRates = rates.map { $0.value }
        
        let excellent = (arrayOfRates.filter { $0 == 5 }.count * 100) / arrayOfRates.count
        let good = (arrayOfRates.filter { $0 == 4 }.count * 100) / arrayOfRates.count
        let average = (arrayOfRates.filter { $0 == 3 }.count * 100) / arrayOfRates.count
        let belowAverage = (arrayOfRates.filter { $0 == 2 }.count * 100) / arrayOfRates.count
        let poor = (arrayOfRates.filter { $0 == 1 }.count * 100) / arrayOfRates.count
        
        let rateDetails = Lecturer.RateDetails(excellent: Float(excellent) / 100,
                                      good: Float(good) / 100,
                                      average: Float(average) / 100,
                                      belowAverage: Float(belowAverage) / 100,
                                      poor: Float(poor) / 100)
        
        return rateDetails
    }

    func isRecomended() -> Bool {
        guard let rates = rates else { return false }
        
        let rating = self.getRating()
        if recommended != nil {
            return recommended!
        } else {
            return rating >= 4.8 && rates.count > 5
        }
    }
    
}
