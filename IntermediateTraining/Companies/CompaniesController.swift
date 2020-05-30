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


        CoreDataManager.shared.pesistentContainer.performBackgroundTask { (backgroundContext) in

            (0...20000).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)

                do {
                    try backgroundContext.save()
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.companies = CoreDataManager.shared.fetchCompanies()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))

        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(doWork))
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

        let context = CoreDataManager.shared.pesistentContainer.viewContext

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

