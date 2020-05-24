//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/24.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {

    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }

    var company: Company?

    var employees = [Employee]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }

    private func fetchEmployees() {
        print("Trying to fetch employees..")

        let context = CoreDataManager.shared.pesistentContainer.viewContext

        let request = NSFetchRequest<Employee>(entityName: "Employee")

        do {
            let employees = try context.fetch(request)

            self.employees = employees
//            employees.forEach{print("Employee name:", $0.name ?? "")}
        } catch let err {
            print("Failed to fetch employees:", err)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)

        return cell
    }

    let cellId = "cellllllId"

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchEmployees()

        tableView.backgroundColor = UIColor.darkBlue

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }

    @objc private func handleAdd() {
        print("Trying to add an employee..")

        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
