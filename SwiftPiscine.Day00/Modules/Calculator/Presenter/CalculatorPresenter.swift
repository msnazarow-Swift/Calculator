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
            handleDigit(digit: buttonTitle)
        case "=":
            handleResult()
        case _ where operations.contains(buttonTitle):
            handleOperations(operationCharecter: buttonTitle)
        case "AC":
            status = .waitForFirstOperand
            output = "0"
            result = 0
            view?.clearInput()
        case ",":
            if output.contains(".") && status != .didCalculation {
                view?.bibError()
            } else {
                handleDigit(digit: ".")
                view?.setDisplayText(output)
            }
        case "+⁄−":
            if status == .waitForSecondOperand || status == .waitForFirstOperand{
                handlePlusMinus()
            } else {
                handleDigit(digit: buttonTitle)
            }
        default:
            break
        }
    }

    private func handleDigit(digit: String) {
        switch status {
        case .waitForFirstOperand, .didCalculation:
            switch digit {
            case dot:
                output = "0\(dot)"
            case plusMinus:
                handlePlusMinus()
            default:
                output = digit
            }
            view?.setDisplayText(output)
            status = .typingFirstOperand
        case .typingFirstOperand, .typingSecondOperand:
            switch digit {
            case plusMinus:
                handlePlusMinus()
            default:
                output.append(digit)
            }

            view?.setDisplayText(output)
        case .waitForSecondOperand:
            switch digit {
            case dot:
                output = "0\(dot)"
            case plusMinus:
                handlePlusMinus()
            default:
                output = digit
            }
            view?.setDisplayText(output)
            status = .typingSecondOperand
        }
    }

    private func handleResult(){
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
    }

    private func handleOperations(operationCharecter: String){
        switch status {
        case .typingFirstOperand, .didCalculation:
            if let result = Double(output) {
                self.result = result
            }
            operation = operationCharecter
            status = .waitForSecondOperand
        case .typingSecondOperand:
            if operationCharecter == "=" || operation != nil {
                guard let operand = Double(output), let operation = operation,
                      let result = calculate(result: result, operation: operation, operand: operand) else { break }
                self.operand = operand
                self.operation = operationCharecter
                pushResult(result: result)
                status = .waitForSecondOperand
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

    private func handlePlusMinus(){
        if output.first == "-" {
            output.removeFirst()
        } else {
            output.insert("-", at: output.startIndex)
        }
    }

    private func pushResult(result: Double) {
        self.result = result
        output = String(format: "%g", result)
        view?.setDisplayText(output)
    }
}
