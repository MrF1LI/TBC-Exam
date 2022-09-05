//
//  Lecturer.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 18.08.22.
//

import Foundation

struct Lecturer: Codable {
    
    struct RateDetails {
        let excellent: Float
        let good: Float
        let average: Float
        let belowAverage: Float
        let poor: Float
    }
    
    let id: String
    let name: String
    let surname: String
    let email: String
    let subject: String
    let profile: String
    var rates: [String:Int]?
    let recommended: Bool?
    
    func getRating() -> Float {
        guard let rates = rates else { return 0 }

        let arrayOfRates = rates.map { $0.value }
        let rating: Float = Float(arrayOfRates.reduce(0, +)) / Float(arrayOfRates.count)
        
        return rating
    }
    
    func getRatingDetails() -> RateDetails? {
        guard let rates = rates else { return nil }
        
        let arrayOfRates = rates.map { $0.value }
        
        let excellent = (arrayOfRates.filter { $0 == 5 }.count * 100) / arrayOfRates.count
        let good = (arrayOfRates.filter { $0 == 4 }.count * 100) / arrayOfRates.count
        let average = (arrayOfRates.filter { $0 == 3 }.count * 100) / arrayOfRates.count
        let belowAverage = (arrayOfRates.filter { $0 == 2 }.count * 100) / arrayOfRates.count
        let poor = (arrayOfRates.filter { $0 == 1 }.count * 100) / arrayOfRates.count
        
        let rateDetails = RateDetails(excellent: Float(excellent) / 100,
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
