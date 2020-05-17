//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/17.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControlelrDelegate {

    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    var companies = [Company]() // empty array

    // let: constant
    // var: variabled that can be modified
//    var companies = [
//        Company(name: "Apple", founded: Date()),
//        Company(name: "Google", founded: Date()),
//        Company(name: "Facebook", founded: Date()),
//    ]

//    func addCompany(company: Company) {
////        let tesla = Company(name: "Tesla", founded: Date())
//
//        //1 - modify your array
//        companies.append(company)
//
//        //2 - insert a new index path into tableview
//        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
//        print("newIndexPath:",newIndexPath)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
//    }

    private func fetchCompanies() {
        // attempt my core data fetch somehow..

//        let persistentContainer = NSPersistentContainer(name: "IntermediateTrainingModels")
//        persistentContainer.loadPersistentStores { (storeDescriotion, err) in
//            if let err = err {
//                fatalError("Loading of store failed: \(err)")
//            }
//        }
//
//        let context = persistentContainer.viewContext

        let context = CoreDataManager.shared.pesistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")


        do {
            let companies = try context.fetch(fetchRequest)

            companies.forEach { (company) in
                print(company.name ?? "")
            }

            self.companies = companies

            self.tableView.reloadData()
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCompanies()

        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TEST ADD", style: .plain, target: self, action: #selector(addCompany))

        view.backgroundColor = .white

        navigationItem.title = "Companies"

        tableView.backgroundColor = .darkBlue
//        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView() // blank UIView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))

    }

    @objc func handleAddCompany() {
        print("Adding company..")

        let createCompanyController = CreateCompanyController()
//        createCompanyController.view.backgroundColor = .green

        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen

        createCompanyController.delegate = self

        present(navController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        cell.backgroundColor = .tealColor

        let company = companies[indexPath.row]

        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
}

