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

struct Student {
    var age: Int!
    var gender: Gender!
    var degree: Degree!
    var isWorkingStudent: Bool!
    var gardenWork: ScenarioQuestions!
    var shopping: ScenarioQuestions!
    var carCleaning: ScenarioQuestions!
    var tutoring: ScenarioQuestions!
    var petSitting: ScenarioQuestions!
}
