//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/17.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {

    var companies = [Company]() // empty array

    @objc func doWork() {
        print("Trying to do work...")


        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in

            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)

                do {
                    try backgroundContext.save()

                    DispatchQueue.main.async {
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let err {
                    print("Failed to save:", err)
                }
            }
        }

        // GCD - Grand Central Dispatch
        DispatchQueue.global(qos: .background).async {

            // creating some Company objects on a background thread

//            let context = CoreDataManager.shared.pesistentContainer.viewContext

            //NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        }
    }

    // let`s do some tricky updates with core data
    @objc private func doUpdates() {
        print("Trying to update companies on a background context")

        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in

            let request: NSFetchRequest<Company> = Company.fetchRequest()


            do {
                let companies = try backgroundContext.fetch(request)

                companies.forEach { (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                }

                do {
                    try backgroundContext.save()

                    // let`s try to update the UI after a save

                    DispatchQueue.main.async {
                        // reset will forget all of the objects you`ve fetch before
                        CoreDataManager.shared.persistentContainer.viewContext.reset()

                        // you don`t want to refetch everything if you`re just simply update one or two companies
                        self.companies = CoreDataManager.shared.fetchCompanies()

                        // is there a way to just merge the changes that you made onto the main view context?
                        self.tableView.reloadData()
                    }
                } catch let saveErr {
                    print("Failed to save on background:", saveErr)
                }

            } catch let err {
                print("Failed to fetch companies on background:", err)
            }
        }
    }

    @objc private func doNestedUpdates() {
        print("Trying to perform nested updates now...")

        DispatchQueue.global(qos: .background).async {
            // we`ll try to perform our updates

            // we`ll first construct a custom MOC

            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext

            // execute updates on privateContext now
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1

            do {
                let companies = try privateContext.fetch(request)
                companies.forEach { (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                }

                do {
                    try privateContext.save()

                    // after save succeeds

                    DispatchQueue.main.async {

                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext

                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData()

                        } catch let finalSaveErr {
                            print("Failed to save main context:", finalSaveErr)
                        }

                    }

                } catch let saveErr {
                    print("Failed to save on private context:", saveErr)
                }


            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }

        }


    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.companies = CoreDataManager.shared.fetchCompanies()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))

        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]


        view.backgroundColor = .white

        navigationItem.title = "Companies"

        tableView.backgroundColor = .darkBlue

        tableView.tableFooterView = UIView() // blank UIView()

        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")

        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
    }

    @objc private func handleReset() {
        print("Attempting to delete all core data objects")

        let context = CoreDataManager.shared.persistentContainer.viewContext

        companies.forEach { (company) in
            context.delete(company)
        }

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())

        do {
            try context.execute(batchDeleteRequest)

            // upon deletion from core data succeeded

            var indexPathsToRemove = [IndexPath]()

            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let delErr {
            print("Failed to delete objects from Core Data", delErr)
        }
    }

    @objc func handleAddCompany() {
        print("Adding company..")

        let createCompanyController = CreateCompanyController()

        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen

        createCompanyController.delegate = self

        present(navController, animated: true, completion: nil)
    }

}

