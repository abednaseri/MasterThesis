//
//  Strings.swift
//  MasterThesis
//
//  Created by Abed on 22.06.19.
//  Copyright © 2019 Webiaturist. All rights reserved.
//

import Foundation
extension String {
    
    // Make a 2 Dimensional Array out of the CSV
    func csv() -> [[String]]{
        var result: [[String]] = []
        let rows = self.components(separatedBy: "\n")
        for row in rows{
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func cleanData() -> String{
        var cleanData = self
        cleanData = cleanData.replacingOccurrences(of: "\r", with: "\n")
        cleanData = cleanData.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanData
    }

}
