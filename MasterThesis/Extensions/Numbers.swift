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
