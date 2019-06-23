//
//  ViewController.swift
//  MasterThesis
//
//  Created by Abed on 20.06.19.
//  Copyright © 2019 Webiaturist. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    var students: [[String]]!
    var households: [[String]]!
    let chartDescriptionText = "This is the description"
    let xAxisTitle = "This is the X Axis Title"
    let yAxisTitle = "This is the y Axis Title"
    
    var femaleStudentsDataEntry = PieChartDataEntry(value: 0)
    var maleStudentsDataEntry = PieChartDataEntry(value: 0)
    var studentsGenderDataEntries = [PieChartDataEntry]()

    @IBOutlet weak var chartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataForAll()
        
        // Charts
        var men = 0.0
        var women = 0.0
        for person in students{
            person[2] == "Weiblich" ? (women += 1.0) : (men += 1.0)
        }
        chartView.chartDescription?.text = chartDescriptionText
        maleStudentsDataEntry.label = xAxisTitle
        maleStudentsDataEntry.value = men
        femaleStudentsDataEntry.label = yAxisTitle
        femaleStudentsDataEntry.value = women
        studentsGenderDataEntries = [femaleStudentsDataEntry, maleStudentsDataEntry]
        let chartDataSet = PieChartDataSet(entries: studentsGenderDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.red, UIColor.blue]
        chartDataSet.colors = colors
        
        chartView.data = chartData
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
            // Remove the title row
            self.students.remove(at: 0)
            // Remove the last empty row (Otherwise app will crash in processing data)
            self.students.remove(at: self.students.count - 1)
        }
        if let householdData = readDataFromCSV(fileName: "households", fileType: "csv"){
            self.households = householdData.csv()
            // Remove the title row
            self.households.remove(at: 0)
            // Remove the last empty row (Otherwise app will crash in processing data)
            self.households.remove(at: self.households.count - 1)
        }
    }
    
    

}

