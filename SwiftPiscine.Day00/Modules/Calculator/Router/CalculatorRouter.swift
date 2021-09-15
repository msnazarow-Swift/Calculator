//
//  CalculatorRouter.swift
//  SwiftPiscine.Day00
//
//  Created by out-nazarov2-ms on 13.09.2021.
//  
//

import UIKit

class CalculatorRouter: PresenterToRouterCalculatorProtocol {

    // MARK: - Properties
    weak var view: UIViewController?

    // MARK: - Init
    init(view: UIViewController) {
        self.view = view
    }
    
}
