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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Create Employee"

        setupCancelButton()

        view.backgroundColor = .darkBlue

        _ = setupLightBlueBackgroundView(height: 50)

        setupUI()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }

    @objc private func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = self.company else { return }

        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, company: company)
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

    private func setupUI() {
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

    }
}
