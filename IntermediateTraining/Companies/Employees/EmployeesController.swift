//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/24.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import UIKit
import CoreData

// lets create a UILabel subclass for custom text drawing
class IndentedLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {

    // remember this is called when we dismiss employee creation
    func didAddEmployee(employee: Employee) {
        // what is the insertion index path?
        guard let section = employeeTypes.index(of: employee.type!) else { return }

        // what is my row?
        let row = allEmployees[section].count

        let insertionIndexPath = IndexPath(row: row, section: section)

        allEmployees[section].append(employee)

        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }

    var company: Company?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = employeeTypes[section]
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    var allEmployees = [[Employee]]()

    var employeeTypes = [
        EmployeeType.Intern.rawValue,
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
    ]

    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }

        allEmployees = []
        // let`s use my array and loop to filter instead
        employeeTypes.forEach { (employeeType) in
            // somehow construct my allEmployees array
            allEmployees.append(companyEmployees.filter { $0.type == employeeType })
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
//        if section == 0 {
//            return shortNameEmployees.count
//        }
//        return longNameEmployees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

//        if indexPath.section == 0 {
//            employee = shortName
//        }

        // i will use ternary operator
//        let employee = indexPath.section == 0 ? shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]

        let employee = allEmployees[indexPath.section][indexPath.row]

        cell.textLabel?.text = employee.name

        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "") \(dateFormatter.string(from: birthday))"

        }

//        if let taxId = employee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "") \(taxId)"
//        }

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
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
