//
//  CalculatorPresenter.swift
//  SwiftPiscine.Day00
//
//  Created by out-nazarov2-ms on 13.09.2021.
//  
//

import Foundation

class CalculatorPresenter: ViewToPresenterCalculatorProtocol {

    // MARK: Properties
    weak var view: PresenterToViewCalculatorProtocol?
    let interactor: PresenterToInteractorCalculatorProtocol?
    let router: PresenterToRouterCalculatorProtocol?

    // MARK: Init
    init(view: PresenterToViewCalculatorProtocol, interactor: PresenterToInteractorCalculatorProtocol?, router: PresenterToRouterCalculatorProtocol?) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func buttonDidTapped(_ buttonTitle: String?) {
        
    }
}
