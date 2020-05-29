//
//  CreateEmployeeController.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/24.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {

    var company: Company?

    var delegate: CreateEmployeeControllerDelegate?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/dd/yyyy"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Create Employee"

        setupCancelButton()

        view.backgroundColor = .darkBlue

        setupUI()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }

    @objc private func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = self.company else { return }

        // turn birthdayTextField.text into a data object

        guard let birthdayText = birthdayTextField.text else { return }

        // let`s perform the validation step here
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "You have not entered a birthday.")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title:  "Bad Date", message: "Birthday date entered not valid.")
            return
        }

        guard let employeeType = employeeTypeSegmentControl.titleForSegment(at: employeeTypeSegmentControl.selectedSegmentIndex) else { return }

        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
        if let error = tuple.1 {
            // is where you present an error model of some kind
            // perhaps use a UIAlertController to show your error message
            print(error)
        } else {
            // creation sucess
            dismiss(animated: true, completion: {
                // we`ll call the delegate somehow
                self.delegate?.didAddEmployee(employee: tuple.0!)
            })
        }
    }

    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    let employeeTypeSegmentControl: UISegmentedControl = {
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManagement.rawValue,
            EmployeeType.Staff.rawValue,
            EmployeeType.Intern.rawValue
        ]
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentTintColor = .darkBlue
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return sc
    }()

    private func setupUI() {

        _ = setupLightBlueBackgroundView(height: 150)

        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor ,constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true

        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor ,constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(birthdayTextField)
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true

        view.addSubview(employeeTypeSegmentControl)
        employeeTypeSegmentControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 0).isActive = true
        employeeTypeSegmentControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        employeeTypeSegmentControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        employeeTypeSegmentControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
}
