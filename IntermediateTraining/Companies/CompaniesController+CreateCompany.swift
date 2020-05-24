//
//  CompaniesController+CreateCompany.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/24.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControlelrDelegate {

    // specify your extension methods here...
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
}
