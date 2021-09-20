//
//  CalculatorContract.swift
//  Calculator
//
//  Created by out-nazarov2-ms on 13.09.2021.
//  
//

import UIKit


// MARK: Globals

var verticalTranslation = UIApplication.shared.statusBarOrientation.isPortrait ? UIScreen.main.bounds.height / 844.0 : UIScreen.main.bounds.height / 390.0
var horisontalTranslation = UIApplication.shared.statusBarOrientation.isPortrait ? UIScreen.main.bounds.width / 390.0 : UIScreen.main.bounds.width / 844.0
let operations = ["=", .multiply, .divide, "-", "+"]
let additions = ["AC", .plusMinus, "%"]

// MARK: View Output (Presenter -> View)
protocol PresenterToViewCalculatorProtocol: AnyObject {
    func setDisplayText(_ text: String)
    func pushHistoryText(_ text: String)
    func clearInput()
    func getResult() -> Double?
    func bibError()
    func switchACButtonTitle(to title: String)
    func clearHistory()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterCalculatorProtocol: AnyObject {
    func buttonDidTapped(_ buttonTitle: String?)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCalculatorProtocol: AnyObject {

}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterCalculatorProtocol: AnyObject {
    
}


