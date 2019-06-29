//
//  MainObject.swift
//  MasterThesis
//
//  Created by Abed on 25.06.19.
//  Copyright © 2019 Webiaturist. All rights reserved.
//

class MainObject {
    var gardenWork: ScenarioQuestions!
    var shopping: ScenarioQuestions!
    var carCleaning: ScenarioQuestions!
    var tutoring: ScenarioQuestions!
    var petSitting: ScenarioQuestions!
    
    init(gardenWork: ScenarioQuestions, shopping: ScenarioQuestions, carCleaning: ScenarioQuestions, tutoring: ScenarioQuestions, petSitting: ScenarioQuestions){
        self.gardenWork = gardenWork
        self.shopping = shopping
        self.carCleaning = carCleaning
        self.tutoring = tutoring
        self.petSitting = petSitting
    }
}

enum Scenarios{
    case Gardening
    case Shopping
    case Car
    case Tutoring
    case PetSitting
}
