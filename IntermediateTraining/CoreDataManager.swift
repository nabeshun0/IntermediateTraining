//
//  CoreDataManager.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/17.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import CoreData

struct CoreDataManager {

    static let shared = CoreDataManager() // will live forever as long as your application is still alive, It`s properties will too

    let pesistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "IntermediateTrainingModels")
        persistentContainer.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return persistentContainer
    }()
}
