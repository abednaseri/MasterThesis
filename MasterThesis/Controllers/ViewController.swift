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
    
    var rawStudents: [[String]]!
    var students: [Student] = []
    var households: [Household] = []
    var rawHouseholds: [[String]]!
    let chartDescriptionText = ""
    
    var dataEntry1PieChart = PieChartDataEntry(value: 0)
    var dataEntry2PieChart = PieChartDataEntry(value: 0)
    var dataEntriesPieChart = [PieChartDataEntry]()

    @IBOutlet weak var chartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataForAll()
        
        calculateWantToUseAtLeastNTimesWithGraph()
        
    }
    
    
    
    
    //
    // FUNCTIONS
    //
    
    // How many people don’t want to use the service (all of them)
    func dontWantToUseTheServiceAtAll(){
        // For Students
        var studentsNotWantingCount = 0.0
        for student in students{
            if !student.gardenWork.willUseService && !student.shopping.willUseService && !student.carCleaning.willUseService && !student.tutoring.willUseService && !student.petSitting.willUseService {
                studentsNotWantingCount += 1
            }
        }
        // For Households
        var householdsNotWanting = 0.0
        for household in households{
            if !household.gardenWork.willUseService && !household.shopping.willUseService && !household.carCleaning.willUseService && !household.tutoring.willUseService && !household.petSitting.willUseService {
                householdsNotWanting += 1
            }
        }
        // Chart
        drawPieChart(data1: householdsNotWanting, label1: "Number Of Households who don't want to use the service at all", data2: Double(households.count) - householdsNotWanting, label2: "Number Of Households who would use the service at least once")
    }
    
    
    
    // How many people want to use at least n times
    func calculateWantToUseAtLeastNTimesWithGraph(){
        var studentsNumbers: [Double] = []
        var householdsNumbers: [Double] = []

        //Students
        studentsNumbers.append(wantToUseAtLeastNTimes(array: students, times: 2).convertToPercentage(with: students.count))
        studentsNumbers.append(wantToUseAtLeastNTimes(array: students, times: 3).convertToPercentage(with: students.count))
        studentsNumbers.append(wantToUseAtLeastNTimes(array: students, times: 4).convertToPercentage(with: students.count))
        studentsNumbers.append(wantToUseAtLeastNTimes(array: students, times: 5).convertToPercentage(with: students.count))
        //Households
        householdsNumbers.append(wantToUseAtLeastNTimes(array: households, times: 2).convertToPercentage(with: households.count))
        householdsNumbers.append(wantToUseAtLeastNTimes(array: households, times: 3).convertToPercentage(with: households.count))
        householdsNumbers.append(wantToUseAtLeastNTimes(array: households, times: 4).convertToPercentage(with: households.count))
        householdsNumbers.append(wantToUseAtLeastNTimes(array: households, times: 5).convertToPercentage(with: households.count))
        
        drawBarChart(xAxis: [2,3,4,5], yAxis: studentsNumbers)
    }
    func wantToUseAtLeastNTimes(array: [MainObject], times: Int = 2) -> Double{
        var numOfPersons = 0
        
        for person in array{
            var numberOfTimes = 0
            if person.gardenWork.willUseService {
                numberOfTimes += 1
            }
            if person.shopping.willUseService {
                numberOfTimes += 1
            }
            if numberOfTimes == times {
                numOfPersons += 1
                continue
            }
            if person.carCleaning.willUseService {
                numberOfTimes += 1
            }
            if numberOfTimes == times {
                numOfPersons += 1
                continue
            }
            if person.tutoring.willUseService{
                numberOfTimes += 1
            }
            if numberOfTimes == times {
                numOfPersons += 1
                continue
            }
            if person.petSitting.willUseService {
                numberOfTimes += 1
            }
            if numberOfTimes == times {
                numOfPersons += 1
            }
        }
        return Double(numOfPersons)
    }
    
    
    // Pie Chart
    func drawPieChart(data1: Double, label1: String, data2: Double, label2: String){
        chartView.chartDescription?.text = chartDescriptionText
        dataEntry2PieChart.label = label1
        dataEntry2PieChart.value = data1
        dataEntry1PieChart.label = label2
        dataEntry1PieChart.value = data2
        dataEntriesPieChart = [dataEntry1PieChart, dataEntry2PieChart]
        let chartDataSet = PieChartDataSet(entries: dataEntriesPieChart, label: nil)
//        chartView.drawEntryLabelsEnabled = false
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(red: 20/255, green: 61/255, blue: 89/255, alpha: 1), UIColor(red: 244/255, green: 180/255, blue: 26/255, alpha: 1)]
        chartDataSet.colors = colors
        
        chartView.data = chartData
    }
    
    
    func drawBarChart(xAxis: [Double], yAxis: [Double]){
        
        var dataEntries: [BarChartDataEntry] = []
        for (index, xEntry) in xAxis.enumerated(){
            let barChartDataEntry = BarChartDataEntry(x: xEntry, y: yAxis[index])
            dataEntries.append(barChartDataEntry)
        }
        
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Percentage of students who would use at least n scenarios.")
//        chartDataSet.colors = [UIColor.green]
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.xAxis.granularity = 1.0
//        chartView.xAxis. = "Hi abeshkjdh vkdh"
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisMaximum = 100
        chartView.rightAxis.axisMaximum = 100
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.axisMinimum = 0
        chartView.data = chartData
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
            self.rawStudents = studentsData.csv()
            // Remove the title row
            self.rawStudents.remove(at: 0)
            // Remove the last empty row (Otherwise app will crash in processing data)
            self.rawStudents.remove(at: self.rawStudents.count - 1)
            for rawStudent in self.rawStudents{
                let student = processStudentObject(rawStudent: rawStudent)
                students.append(student)
            }
        }
        if let householdData = readDataFromCSV(fileName: "households", fileType: "csv"){
            self.rawHouseholds = householdData.csv()
            // Remove the title row
            self.rawHouseholds.remove(at: 0)
            // Remove the last empty row (Otherwise app will crash in processing data)
            self.rawHouseholds.remove(at: self.rawHouseholds.count - 1)
            for rawHousehold in rawHouseholds{
                let household = processHouseholdObject(rawHousehold: rawHousehold)
                households.append(household)
            }
        }
    }
    
    func processStudentObject(rawStudent: [String]) -> Student{
        let student = Student(
            age: Int(rawStudent[1]) ?? -1,
            gender: rawStudent[2] == "Weiblich" ? Gender.Female : rawStudent[2] == "Männlich" ? Gender.Male : Gender.Diverse,
            degree: rawStudent[3] == "Bachelor" ? Degree.Bachelor: rawStudent[3] == "Master" ? Degree.Master : rawStudent[3] == "PhD" ? Degree.PhD : Degree.Other,
            isWorkingStudent: rawStudent[4] == "Ja",
            gardenWork: ScenarioQuestions(
                canImagine: rawStudent[5] == "Ja",
                willUseService: rawStudent[6] == "Ja",
                price: Int(rawStudent[7])),
            shopping: ScenarioQuestions(
                canImagine: rawStudent[8] == "Ja",
                willUseService: rawStudent[9] == "Ja",
                price: Int(rawStudent[10])),
            carCleaning: ScenarioQuestions(
                canImagine: rawStudent[11] == "Ja",
                willUseService: rawStudent[12] == "Ja",
                price: Int(rawStudent[13])),
            tutoring: ScenarioQuestions(
                canImagine: rawStudent[14] == "Ja",
                willUseService: rawStudent[15] == "Ja",
                price: Int(rawStudent[16])),
            petSitting: ScenarioQuestions(
                canImagine: rawStudent[17] == "Ja",
                willUseService: rawStudent[18] == "Ja",
                price: Int(rawStudent[19]))
        )
        return student
    }
    
    func processHouseholdObject(rawHousehold: [String]) -> Household{
        let household = Household(
            age: Int(rawHousehold[1]) ?? 0,
            gender: rawHousehold[2] == "Weiblich" ? Gender.Female : rawHousehold[2] == "Männlich" ? Gender.Male : Gender.Diverse,
            relationshipStatus: rawHousehold[3] == "In einer Beziehung" ? Relationship.InARelationship : rawHousehold[3] == "Ledig" ? Relationship.Single : rawHousehold[3] == "Verheiratet" ? Relationship.Married : Relationship.Other,
            jobStatus: rawHousehold[4] == "Angestellt" ? JobStatus.Employed : rawHousehold[4] == "Selbständig" ? JobStatus.SelfEmployed : rawHousehold[4] == "Arbeitslos" ? JobStatus.JobLess : JobStatus.Other,
            numberOfPersonsInHome: Int(rawHousehold[5]) ?? 0,
            stressLevel: Int(rawHousehold[6]) ?? 0,
            gardenWork: ScenarioQuestions(
                canImagine: rawHousehold[7] == "Ja",
                willUseService: rawHousehold[8] == "Ja",
                price: Int(rawHousehold[9])),
            shopping: ScenarioQuestions(
                canImagine: rawHousehold[10] == "Ja",
                willUseService: rawHousehold[11] == "Ja",
                price: Int(rawHousehold[12])),
            carCleaning: ScenarioQuestions(
                canImagine: rawHousehold[13] == "Ja",
                willUseService: rawHousehold[14] == "Ja",
                price: Int(rawHousehold[15])),
            tutoring: ScenarioQuestions(
                canImagine: rawHousehold[16] == "Ja",
                willUseService: rawHousehold[17] == "Ja",
                price: Int(rawHousehold[18])),
            petSitting: ScenarioQuestions(
                canImagine: rawHousehold[19] == "Ja",
                willUseService: rawHousehold[20] == "Ja",
                price: Int(rawHousehold[21]))
        )
        return household
    }
    
    
    func getNumberFormat() -> NumberFormatter{
        let formatter = NumberFormatter()
//        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1.0
        return formatter
    }
    

}

