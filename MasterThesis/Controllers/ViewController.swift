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
        drawPieChart()
        dontWantToUseTheServiceAtAll()
        
    }
    
    
    
    
    //
    // FUNCTIONS
    //
    
    // How many people don’t want to use the service (all of them)
    func dontWantToUseTheServiceAtAll(){
        for student in students{
            if !student.gardenWork.willUseService && !student.shopping.willUseService && !student.carCleaning.willUseService && !student.tutoring.willUseService && !student.petSitting.willUseService {
                print("Asshole")
            }
//            if student[6] == "Nein" && student[9] == "Nein" && student[12] == "Nein" && student[15] == "Nein" && student[18] == "Nein"{
//                print("Asshole")
//            }
        }
    }
    
    
    // Pie Chart
    func drawPieChart(){
        var men = 0.0
        var women = 0.0
        for person in rawStudents{
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
            age: Int(rawStudent[1]),
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
            age: Int(rawHousehold[1]),
            gender: rawHousehold[2] == "Weiblich" ? Gender.Female : rawHousehold[2] == "Männlich" ? Gender.Male : Gender.Diverse,
            relationshipStatus: rawHousehold[3] == "In einer Beziehung" ? Relationship.InARelationship : rawHousehold[3] == "Ledig" ? Relationship.Single : rawHousehold[3] == "Verheiratet" ? Relationship.Married : Relationship.Other,
            jobStatus: rawHousehold[4] == "Angestellt" ? JobStatus.Employed : rawHousehold[4] == "Selbständig" ? JobStatus.SelfEmployed : rawHousehold[4] == "Arbeitslos" ? JobStatus.JobLess : JobStatus.Other,
            numberOfPersonsInHome: Int(rawHousehold[5]),
            stressLevel: Int(rawHousehold[6]),
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
    
    

}

