//
//  Numbers.swift
//  MasterThesis
//
//  Created by Abed on 29.06.19.
//  Copyright © 2019 Webiaturist. All rights reserved.
//

extension Double{
    func convertToPercentage(with maxLimit: Int) -> Double{
        return self * 100 / Double(maxLimit)
    }
}

extension Collection where Element: Numeric{
    // Sum the values of an Array of Numbers
    var sumValue: Element { return reduce(0, +)}
}

extension Collection where Element: BinaryInteger{
    // Calculate Average of Array
    var average: Double {
        return isEmpty ? 0 : Double(sumValue) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint{
    // Calculate Average of Array
    var average: Double {
        return isEmpty ? 0 : Double(sumValue) / Double(count)
    }
}



