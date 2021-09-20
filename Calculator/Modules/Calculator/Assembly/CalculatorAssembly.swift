//
//  CalculatorAssembly.swift
//  Calculator
//
//  Created by out-nazarov2-ms on 13.09.2021.
//  
//

import UIKit

enum CalculatorAssembly{
    
    // MARK: Static methods
    static func createModule() -> UIViewController {

        let viewController = CalculatorViewController()
        let router = CalculatorRouter(view: viewController)
        let interactor = CalculatorInteractor()
        let presenter = CalculatorPresenter(view: viewController, interactor: interactor, router: router)

        viewController.presenter = presenter

        return viewController
    }
}
