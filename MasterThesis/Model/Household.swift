//
//  Household.swift
//  MasterThesis
//
//  Created by Abed on 23.06.19.
//  Copyright © 2019 Webiaturist. All rights reserved.
//

class Household: MainObject {
    var age: Int
    var gender: Gender
    var relationshipStatus: Relationship
    var jobStatus: JobStatus
    var numberOfPersonsInHome: Int
    var stressLevel: Int
    
    init(age: Int, gender: Gender, relationshipStatus: Relationship, jobStatus: JobStatus, numberOfPersonsInHome: Int, stressLevel: Int, gardenWork: ScenarioQuestions, shopping: ScenarioQuestions, carCleaning: ScenarioQuestions, tutoring: ScenarioQuestions, petSitting: ScenarioQuestions){
        self.age = age
        self.gender = gender
        self.relationshipStatus = relationshipStatus
        self.jobStatus = jobStatus
        self.numberOfPersonsInHome = numberOfPersonsInHome
        self.stressLevel = stressLevel
        
        super.init(gardenWork: gardenWork, shopping: shopping, carCleaning: carCleaning, tutoring: tutoring, petSitting: petSitting)
    }

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
