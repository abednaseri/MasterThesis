//
//  Student.swift
//  MasterThesis
//
//  Created by Abed on 23.06.19.
//  Copyright © 2019 Webiaturist. All rights reserved.
//

enum Gender {
    case Male
    case Female
    case Diverse
}

enum Degree {
    case Bachelor
    case Master
    case PhD
    case Other
}

class Student: MainObject {
    var age: Int
    var gender: Gender!
    var degree: Degree!
    var isWorkingStudent: Bool!
    
    init(age: Int, gender: Gender, degree: Degree, isWorkingStudent: Bool, gardenWork: ScenarioQuestions, shopping: ScenarioQuestions, carCleaning: ScenarioQuestions, tutoring: ScenarioQuestions, petSitting: ScenarioQuestions) {
        self.age = age
        self.gender = gender
        self.degree = degree
        self.isWorkingStudent = isWorkingStudent
        
        super.init(gardenWork: gardenWork, shopping: shopping, carCleaning: carCleaning, tutoring: tutoring, petSitting: petSitting)
    }
}
