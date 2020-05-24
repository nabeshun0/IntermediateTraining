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
        let container = NSPersistentContainer(name: "IntermediateTrainingModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()

    func fetchCompanies() -> [Company] {
        let context = pesistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")

        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
            return []
        }
    }

    func createEmployee(employeeName: String) -> Error? {
        let context = pesistentContainer.viewContext

        //create an employee
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)

        employee.setValue(employeeName, forKey: "name")

        do {
            try context.save()
            // save suceeds
            return nil
        } catch let err {
            print("Failed to create employee:", err)
            return err
        }
    }
}
