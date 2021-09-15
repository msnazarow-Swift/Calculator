//
//  CalculatorContract.swift
//  SwiftPiscine.Day00
//
//  Created by out-nazarov2-ms on 13.09.2021.
//  
//

import UIKit


// MARK: Globals

var verticalTranslation = UIApplication.shared.statusBarOrientation.isPortrait ? UIScreen.main.bounds.height / 844.0 : UIScreen.main.bounds.height / 390.0
var horisontalTranslation = UIApplication.shared.statusBarOrientation.isPortrait ? UIScreen.main.bounds.width / 390.0 : UIScreen.main.bounds.width / 844.0
let digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
let operations = ["=", "×", "÷", "-", "+"]
let additions = ["AC", "+⁄−", "%"]
let comma = ","
// MARK: View Output (Presenter -> View)
protocol PresenterToViewCalculatorProtocol: AnyObject {
   
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

