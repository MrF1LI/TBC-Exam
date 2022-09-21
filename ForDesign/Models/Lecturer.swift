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
    
}
