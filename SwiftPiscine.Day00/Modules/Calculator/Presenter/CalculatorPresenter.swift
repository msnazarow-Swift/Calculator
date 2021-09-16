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

    var output: String = "0"
    var result: Double = 0
    var operand: Double?
    var operation: String?
    var didCalculation: Bool = false

    enum Status {
        case waitForFirstOperand
        case typingFirstOperand
        case waitForSecondOperand
        case typingSecondOperand
        case didCalculation
    }
    var status: Status = .waitForFirstOperand
    // MARK: Init
    init(view: PresenterToViewCalculatorProtocol, interactor: PresenterToInteractorCalculatorProtocol?, router: PresenterToRouterCalculatorProtocol?) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func buttonDidTapped(_ buttonTitle: String?) {
        guard let buttonTitle = buttonTitle else {
            return
        }
        switch buttonTitle {
        case "0"..."9":
            switch status {
            case .waitForFirstOperand, .didCalculation:
                output = buttonTitle
                view?.setDisplayText(buttonTitle)
                status = .typingFirstOperand
            case .typingFirstOperand, .typingSecondOperand:
                output.append(buttonTitle)
                view?.setDisplayText(output)
            case .waitForSecondOperand:
                output = buttonTitle
                view?.setDisplayText(buttonTitle)
                status = .typingSecondOperand
            }
        case "=":
            if status == .typingSecondOperand {
                if let operation = operation, let operand = Double(output),
                   let result = calculate(result: result, operation: operation, operand: operand){
                    self.result = result
                    self.operand = operand
                    pushResult(result: self.result)
                    didCalculation = true
                }
                status = .didCalculation
            } else if status == .didCalculation {
                if let operation = operation, let operand = operand,
                   let result = calculate(result: result, operation: operation, operand: operand){
                    self.result = result
                    pushResult(result: self.result)
                    didCalculation = true
                }
            }
        case _ where operations.contains(buttonTitle):

            didCalculation = true
            switch status {
            case .typingFirstOperand, .didCalculation:
                if let result = Double(output) {
                    self.result = result
                }
                operation = buttonTitle
                status = .waitForSecondOperand
            case .typingSecondOperand:
                if buttonTitle == "=" || operation != nil {
                    guard let operand = Double(output), let operation = operation,
                          let result = calculate(result: result, operation: operation, operand: operand) else { break }
                    self.operand = operand
                    self.operation = buttonTitle
                    pushResult(result: result)
                    status = .waitForSecondOperand
                }
            default:
                break
            }
        case "AC":
            status = .waitForFirstOperand
            output = "0"
            result = 0
            view?.clearInput()
        case ",":
            if output.contains(",") {
                view?.bibError()
            } else {
                output += ","
                view?.setDisplayText(output)
            }
        default:
            break
        }
    }

    private func calculate(result: Double, operation: String, operand: Double) -> Double? {
        switch operation {
        case "+":
            return (result + operand)
        case "-":
            return (result - operand)
        case "*", "×":
            return (result * operand)
        case "/", "÷":
            return (result / operand)
        default:
            return nil
        }
    }

    private func pushResult(result: Double) {
        self.result = result
        output = String(format: "%g", result)
        view?.setDisplayText(output)
    }
}
