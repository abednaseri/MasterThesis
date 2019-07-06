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
    var studentsCount: Int!
    var householdsCount: Int!
    let chartDescriptionText = ""
    
    var dataEntry1PieChart = PieChartDataEntry(value: 0)
    var dataEntry2PieChart = PieChartDataEntry(value: 0)
    var dataEntriesPieChart = [PieChartDataEntry]()

    @IBOutlet weak var chartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataForAll()
        
        numberOfPeopleWhoFoundAPersonToDoATask()
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
        drawPieChart(data1: studentsNotWantingCount.convertToPercentage(with: studentsCount), label1: "Percentage Of Students Who Don't Want To Use The Service At All", data2: (Double(students.count) - studentsNotWantingCount).convertToPercentage(with: studentsCount), label2: "Percentage Of Students Who Would Use The Service At Least Once")
    }
    
    
    
    // How many people want to use at least n times
    func calculateWantToUseAtLeastNTimesWithGraph(){
        var studentsNumbers: [Double] = []
        var householdsNumbers: [Double] = []

        //Students
        studentsNumbers.append(wantToUseAtLeastNTimes(array: students, times: 2).convertToPercentage(with: studentsCount))
        studentsNumbers.append(wantToUseAtLeastNTimes(array: students, times: 3).convertToPercentage(with: studentsCount))
        studentsNumbers.append(wantToUseAtLeastNTimes(array: students, times: 4).convertToPercentage(with: studentsCount))
        studentsNumbers.append(wantToUseAtLeastNTimes(array: students, times: 5).convertToPercentage(with: studentsCount))
        //Households
        householdsNumbers.append(wantToUseAtLeastNTimes(array: households, times: 2).convertToPercentage(with: householdsCount))
        householdsNumbers.append(wantToUseAtLeastNTimes(array: households, times: 3).convertToPercentage(with: householdsCount))
        householdsNumbers.append(wantToUseAtLeastNTimes(array: households, times: 4).convertToPercentage(with: householdsCount))
        householdsNumbers.append(wantToUseAtLeastNTimes(array: households, times: 5).convertToPercentage(with: householdsCount))
        
        drawBarChart(xAxis: [2,3,4,5], yAxis: studentsNumbers, label: "Percentage of students who would use at least n scenarios.")
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
    
    // Show Scenarios Popularity Graph
    func showScenariosPopularityGraph(){
        let popularityHouseholds = claculateScenarioPopularity(array: households)
        let results2 = [
            Double(popularityHouseholds[Scenarios.Gardening]!).convertToPercentage(with: householdsCount),
            Double(popularityHouseholds[Scenarios.Shopping]!).convertToPercentage(with: householdsCount),
            Double(popularityHouseholds[Scenarios.Car]!).convertToPercentage(with: householdsCount),
            Double(popularityHouseholds[Scenarios.Tutoring]!).convertToPercentage(with: householdsCount),
            Double(popularityHouseholds[Scenarios.PetSitting]!).convertToPercentage(with: householdsCount)
        ]
        let popularityStudents = claculateScenarioPopularity(array: students)
        let results1 = [
            Double(popularityStudents[Scenarios.Gardening]!).convertToPercentage(with: studentsCount),
            Double(popularityStudents[Scenarios.Shopping]!).convertToPercentage(with: studentsCount),
            Double(popularityStudents[Scenarios.Car]!).convertToPercentage(with: studentsCount),
            Double(popularityStudents[Scenarios.Tutoring]!).convertToPercentage(with: studentsCount),
            Double(popularityStudents[Scenarios.PetSitting]!).convertToPercentage(with: studentsCount)
        ]
        //        let array = popularity.values.map{ Double($0).convertToPercentage(with: students.count) } // Changing order of numbers, don't know why
        
        //        drawBarChart(xAxis: [0,1,2,3,4], yAxis: results, label: "Percentage Of Popularity Of Scenarios Among Households.")
        drawGroupedBarChart(xAxis: [0,1,2,3,4], yAxis1: results1, yAxis2: results2, label: "Percentage Of Popularity Of Scenarios Among Households.")
    }
    
    // Calculate Popularity
    func claculateScenarioPopularity(array: [MainObject]) -> [Scenarios: Int]{
        var popularity = [
            Scenarios.Gardening: 0,
            Scenarios.Shopping: 0,
            Scenarios.Car: 0,
            Scenarios.Tutoring: 0,
            Scenarios.PetSitting: 0
        ]
        for person in array{
            popularity[Scenarios.Gardening]! += person.gardenWork.willUseService ? 1 : 0
            popularity[Scenarios.Shopping]! += person.shopping.willUseService ? 1 : 0
            popularity[Scenarios.Car]! += person.carCleaning.willUseService ? 1 : 0
            popularity[Scenarios.Tutoring]! += person.tutoring.willUseService ? 1 : 0
            popularity[Scenarios.PetSitting]! += person.petSitting.willUseService ? 1 : 0
        }
        return popularity
    }
    
    // What is the percentage of people who want to use this service for every gender?
    func getPercentageOfPeopleWantingToUseServiceForEveryGender(){
        var results: [Gender: Int] = [
            Gender.Male: 0,
            Gender.Female: 0
        ]
        for person in households{
            if person.gardenWork.willUseService || person.shopping.willUseService || person.carCleaning.willUseService || person.tutoring.willUseService || person.petSitting.willUseService {
                person.gender == Gender.Male ? (results[Gender.Male]! += 1) : (results[Gender.Female]! += 1)
            }
        }
        let sumOfPositives = results[Gender.Male]! + results[Gender.Female]!
        print("Sum is \(sumOfPositives)")
        print(results)
        print("Male \(Double(results[Gender.Male]!).convertToPercentage(with: sumOfPositives))")
        print("Female \(Double(results[Gender.Female]!).convertToPercentage(with: sumOfPositives))")
    }
    
    // What is the percentage of people who want to use this service for every age group?
    func getPercentageOfPeopleWantingToUseServiceForEveryAgeGroup(){
        var results = [
            "UpTo25": 0,
            "26-35": 0,
            "36-45": 0,
            "46-55": 0,
            "56Above": 0
        ]
        for person in students{
            if person.gardenWork.willUseService || person.shopping.willUseService || person.carCleaning.willUseService || person.tutoring.willUseService || person.petSitting.willUseService {
                results["UpTo25"]! += AgeGroups.UpTo25.contains(person.age) ? 1 : 0
                results["26-35"]! += AgeGroups.From26To35.contains(person.age) ? 1 : 0
                results["36-45"]! += AgeGroups.From36To45.contains(person.age) ? 1 : 0
                results["46-55"]! += AgeGroups.From46To55.contains(person.age) ? 1 : 0
                results["56Above"]! += AgeGroups.From56Above.contains(person.age) ? 1 : 0
            }
        }
        let sumOfPositives = 50 // 60 or 50
        print("Sum is \(sumOfPositives)")
        print(results)
    }
    
    // What is the percentage of people who want to use this service for Relationship Status?
    func getPercentageOfPeopleWantingToUseServiceForRelationshipStatus(){
        var results = [
            Relationship.InARelationship: 0,
            Relationship.Married: 0,
            Relationship.Single: 0,
            Relationship.Other: 0
        ]
        for person in households{
            if person.gardenWork.willUseService || person.shopping.willUseService || person.carCleaning.willUseService || person.tutoring.willUseService || person.petSitting.willUseService {
                results[Relationship.InARelationship]! += person.relationshipStatus == Relationship.InARelationship ? 1 : 0
                results[Relationship.Married]! += person.relationshipStatus == Relationship.Married ? 1 : 0
                results[Relationship.Single]! += person.relationshipStatus == Relationship.Single ? 1 : 0
                results[Relationship.Other]! += person.relationshipStatus == Relationship.Other ? 1 : 0
            }
        }
        print(results)
    }
    
    // What is the percentage of people who want to use this service based on Stress Level?
    func getPercentageOfPeopleWantingToUseServiceForStressLevel(){
        var popularity = [
            Scenarios.Gardening: 0,
            Scenarios.Shopping: 0,
            Scenarios.Car: 0,
            Scenarios.Tutoring: 0,
            Scenarios.PetSitting: 0
        ]
        for person in households{
            popularity[Scenarios.Gardening]! += (person.gardenWork.willUseService && person.stressLevel >= 4) ? 1 : 0
            popularity[Scenarios.Shopping]! += (person.shopping.willUseService && person.stressLevel >= 4) ? 1 : 0
            popularity[Scenarios.Car]! += (person.carCleaning.willUseService && person.stressLevel >= 4) ? 1 : 0
            popularity[Scenarios.Tutoring]! += (person.tutoring.willUseService && person.stressLevel >= 4) ? 1 : 0
            popularity[Scenarios.PetSitting]! += (person.petSitting.willUseService && person.stressLevel >= 4) ? 1 : 0
        }
        print(popularity)
        print("Gardening \(10.0.convertToPercentage(with: 50))")
        print("Shopping \(10.0.convertToPercentage(with: 50))")
        print("Car \(11.0.convertToPercentage(with: 50))")
        print("Tutoring \(13.0.convertToPercentage(with: 50))")
        print("PetSitting \(6.0.convertToPercentage(with: 50))")
    }
    
    // What is Number of Times people want to use scenarios based on Stress Level?
    func getNTimesUseOfScenariosForStressLevel(){
        let stressed = households.filter { $0.stressLevel >= 4 }
        let notStressed = households.filter { $0.stressLevel < 4 }
        
        let stressedResults = [
            1: wantToUseAtLeastNTimes(array: stressed, times: 1).convertToPercentage(with: stressed.count),
            2: wantToUseAtLeastNTimes(array: stressed, times: 2).convertToPercentage(with: stressed.count),
            3: wantToUseAtLeastNTimes(array: stressed, times: 3).convertToPercentage(with: stressed.count),
            4: wantToUseAtLeastNTimes(array: stressed, times: 4).convertToPercentage(with: stressed.count),
            5: wantToUseAtLeastNTimes(array: stressed, times: 5).convertToPercentage(with: stressed.count)
        ]
        print(stressedResults)
        
        let notStressedResults = [
            1: wantToUseAtLeastNTimes(array: notStressed, times: 1).convertToPercentage(with: notStressed.count),
            2: wantToUseAtLeastNTimes(array: notStressed, times: 2).convertToPercentage(with: notStressed.count),
            3: wantToUseAtLeastNTimes(array: notStressed, times: 3).convertToPercentage(with: notStressed.count),
            4: wantToUseAtLeastNTimes(array: notStressed, times: 4).convertToPercentage(with: notStressed.count),
            5: wantToUseAtLeastNTimes(array: notStressed, times: 5).convertToPercentage(with: notStressed.count)
        ]
        print(notStressedResults)
    }
    
    func getPercentageOfPeopleWantingToUseServiceForStudentDegree(){
        var results = [
            Degree.Bachelor: 0.0,
            Degree.Master: 0.0
        ]
        for person in students{
            if person.petSitting.willUseService /*|| person.shopping.willUseService || person.carCleaning.willUseService || person.tutoring.willUseService || person.petSitting.willUseService */{
                results[Degree.Bachelor]! += person.degree == Degree.Bachelor ? 1 : 0
                results[Degree.Master]! += person.degree == Degree.Master ? 1 : 0
            }
        }
        let sum = results[Degree.Bachelor]! + results[Degree.Master]!
        print(results[Degree.Bachelor]!.convertToPercentage(with: Int(sum)))
        print(results[Degree.Master]!.convertToPercentage(with: Int(sum)))
    }
    
    // Average Price For Each Scenario
    func averagePriceForEachScenario(){
        var priceArrayStd: [Int] = []
        var priceArrayHsd: [Int] = []
        for person in students{
            if let price = person.petSitting.price{
                priceArrayStd.append(price)
            }
        }
        for person in households{
            if let price = person.petSitting.price{
                priceArrayHsd.append(price)
            }
        }
        print("Students \(priceArrayStd.average)")
        print("Households \(priceArrayHsd.average)")
    }
    
    // Median Price For Each Scenario
    func medianPriceForEachScenario(){
        var priceArrayStd: [Int] = []
        var priceArrayHsd: [Int] = []
        for person in students{
            if let price = person.tutoring.price{
                priceArrayStd.append(price)
            }
        }
        for person in households{
            if let price = person.tutoring.price{
                priceArrayHsd.append(price)
            }
        }
        print(median(array: priceArrayStd))
        print(median(array: priceArrayHsd))
    }
    
    
    
    
    
    // How many people found someone to do the work/give a job for the offered price
    func numberOfPeopleWhoFoundAPersonToDoATask(){
        var results: [Int:Int] = [:]
        var allWantingInThisCategory = 0
        for person in households{
            if let price = person.gardenWork.price{
                allWantingInThisCategory += 1
                let matchingOnes = students.filter { (student) -> Bool in
                    return student.gardenWork.willUseService && student.gardenWork.price != nil && student.gardenWork.price <= price
                }
                results[price] = matchingOnes.count
            }
        }
        let onlyValues = results.map { (key, value) -> Int in
            return value
        }
        // Show Average
        print(onlyValues.average.convertToPercentage(with: allWantingInThisCategory))
        // Show all
        print(results)
        print(allWantingInThisCategory)
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
    
    
    func drawBarChart(xAxis: [Double], yAxis: [Double], label: String){
        let formatter = BarChartFormatter()
        let xaxis = XAxis()
        
        var dataEntries: [BarChartDataEntry] = []
        for (index, xEntry) in xAxis.enumerated(){
            let barChartDataEntry = BarChartDataEntry(x: xEntry, y: yAxis[index])
            dataEntries.append(barChartDataEntry)
            formatter.stringForValue(Double(index), axis: xaxis)
        }
        xaxis.valueFormatter = formatter
        
        chartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: label)
        chartDataSet.colors = [UIColor.green]
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisMaximum = 100
        chartView.rightAxis.axisMaximum = 100
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.axisMinimum = 0
        chartView.data = chartData
    }
    
    func drawGroupedBarChart(xAxis: [Double], yAxis1: [Double], yAxis2: [Double], label: String) {
        let formatter = BarChartFormatter()
        let xaxis = XAxis()
        
        chartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for (index, xEntry) in xAxis.enumerated(){
            
            let dataEntry = BarChartDataEntry(x: xEntry, y: yAxis1[index])
            dataEntries.append(dataEntry)
            
            let dataEntry2 = BarChartDataEntry(x: xEntry, y: yAxis2[index])
            dataEntries1.append(dataEntry2)
            
            formatter.stringForValue(Double(index), axis: xaxis)
        }
        xaxis.valueFormatter = formatter
        chartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Students")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Households")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        //chartDataSet.colors = ChartColorTemplates.colorful()
        //let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = 5
        let startYear = 0
        
        
        chartData.barWidth = barWidth;
        chartView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        chartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        chartView.notifyDataSetChanged()
        chartView.data = chartData
        
        //background color
//        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //chart animation
//        chartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
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
            studentsCount = students.count
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
            householdsCount = households.count
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
    

    func median(array: [Int]) -> Float {
        let sorted = array.sorted()
        if sorted.count % 2 == 0{
            return Float((sorted[sorted.count / 2] + sorted[(sorted.count / 2) - 1])) / 2
        }else{
            return Float(sorted[(sorted.count - 1 ) / 2])
        }
    }
}

