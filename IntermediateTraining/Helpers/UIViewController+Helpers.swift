//
//  UIViewController+Helpers.swift
//  IntermediateTraining
//
//  Created by member on 2020/05/24.
//  Copyright © 2020 Shunta Nabezawa. All rights reserved.
//

import UIKit

extension UIViewController {

    //my extension/helper mehtods

    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }

    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleCancelModel))
    }

    @objc func handleCancelModel() {
        dismiss(animated: true, completion: nil)
    }
}
