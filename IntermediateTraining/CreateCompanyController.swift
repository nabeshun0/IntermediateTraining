//
//  CreateCompanyController.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/17.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import UIKit

// Custom Delegation

protocol CreateCompanyControlelrDelegate {
    func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {

    // not tightly-coupled
    var delegate: CreateCompanyControlelrDelegate?

//    var companiesController: CompaniesController?

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

        setupUI()

        navigationItem.title = "Create Company"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))

        view.backgroundColor = .darkBlue
    }

    @objc func handleSave() {
        print("Trying to save company...")

        dismiss(animated: true) {
            guard let name = self.nameTextField.text else { return }
            let company = Company(name: name, founded: Date())
            self.delegate?.didAddCompany(company: company)
        }
    }

    private func setupUI() {

        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true



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

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
