//
//  ViewController.swift
//  MasterThesis
//
//  Created by Abed on 20.06.19.
//  Copyright © 2019 Webiaturist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var students: [[String]]!
    var households: [[String]]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataForAll()
    }
    
    
    
    
    //
    // FUNCTIONS
    //
    
    
    // MARK: Read Data from CSV
    func readDataFromCSV(fileName: String, fileType: String) -> String?{
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileType) else { return nil }
        do {
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            return contents.cleanData()
        }catch{
            print("Error happened")
            return nil
        }
    }
    
    // MARK: Load Data and Initialize
    func loadDataForAll(){
        if let studentsData = readDataFromCSV(fileName: "students", fileType: "csv"){
            self.students = studentsData.csv()
            print(students[1][2])
        }
        if let householdData = readDataFromCSV(fileName: "households", fileType: "csv"){
            self.households = householdData.csv()
            print(households[1])
        }
    }
    
    

}

