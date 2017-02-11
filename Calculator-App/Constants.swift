//
//  Constants.swift
//  Calculator-App
//
//  Created by Zsolt Szabo on 2/11/17.
//  Copyright © 2017 Zsolt Szabo. All rights reserved.
//

import Foundation

struct Constants {
    struct Math {
        static let numberOfDigitsAfterDecimalPoint = 6
        static let variableName = "M"
    }
    
    struct Drawing {
        static let pointsPerUnit = 40.0
    }
    
    struct Error {
        static let data = "Calculator: DataSource wasn't found"
        static let partialResult = "Calculator: Trying to draw a partial result"
    }
    
}
