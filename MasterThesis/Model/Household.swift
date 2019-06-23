//
//  Household.swift
//  MasterThesis
//
//  Created by Abed on 23.06.19.
//  Copyright © 2019 Webiaturist. All rights reserved.
//

struct Household {
    var age: Int!
    var gender: Gender!
    var relationshipStatus: Relationship!
    var jobStatus: JobStatus!
    var numberOfPersonsInHome: Int!
    var stressLevel: Int!
    var gardenWork: ScenarioQuestions!
    var shopping: ScenarioQuestions!
    var carCleaning: ScenarioQuestions!
    var tutoring: ScenarioQuestions!
    var petSitting: ScenarioQuestions!
}


enum Relationship {
    case Single
    case Married
    case InARelationship
    case Other
}

enum JobStatus {
    case Employed
    case SelfEmployed
    case JobLess
    case Other
}
