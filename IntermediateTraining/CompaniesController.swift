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

    func didEditCompany(company: Company) {
        // update my tableview somehow
        let row = companies.index(of: company)

        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }

    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    var companies = [Company]() // empty array

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            print("Attempting to delete company:", company.name ?? "")

            // remove the company from our tableview
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

            // delete the company from Core Data
            let context  = CoreDataManager.shared.pesistentContainer.viewContext

            context.delete(company)

            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete company:", saveErr)
            }
        }

        deleteAction.backgroundColor = UIColor.lightRed

        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = .darkBlue
        return [deleteAction, editAction]
    }

    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("Editing company in separate function")

        let editCompanyController = CreateCompanyController()
        editCompanyController.delegate = self
        editCompanyController.company = companies[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

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

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))

        view.backgroundColor = .white

        navigationItem.title = "Companies"

        tableView.backgroundColor = .darkBlue
//        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView() // blank UIView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
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


//            companies.forEach { (company) in
//                // but this loop doesn`t provide us with the row number
//                companies.index(of: <#T##Company#>)
//            }
//            companies.removeAll()
//            tableView.reloadData()
        } catch let delErr {
            print("Failed to delete objects from Core Data", delErr)
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
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

        if let name = company.name, let founded = company.founded {

            // MMM dd, yyyy
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMM dd, yyyy"

            let foundedDateString = dateformatter.string(from: founded)

//            let locale = Locale(identifier: "EN")

            let dateString = "\(name) - Founded: \(foundedDateString)"

            cell.textLabel?.text = dateString
        } else {
            cell.textLabel?.text = company.name
        }

        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")

        if let imageData = company.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
}

