//
//  BaseViewController.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 12/1/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController , UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
}
