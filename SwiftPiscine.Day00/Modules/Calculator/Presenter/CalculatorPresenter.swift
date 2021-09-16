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
    var historyText: String = ""
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
                view?.setDisplayText(output)
            } else {
                handleDigit(digit: buttonTitle)
            }
        case "%":
            switch status {
            case .typingFirstOperand:
                guard let result = Double(output) else { return }
                self.result = result
                status = .didCalculation
                operand = 0.01
                operation = multiply
                handleResult()
            case .typingSecondOperand:
                handleOperations(operationCharecter: "")
                guard let result = Double(output) else { return }
                self.result = result
                status = .didCalculation
                operand = 0.01
                operation = multiply
                handleResult()
            default:
                break
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
                view?.pushHistoryText(historyText + " \(operation) \(output) = \(String(format: "%g", result))\n")
                historyText = String(format: "%g", result)
                pushResult(result: self.result)
            }
            status = .didCalculation
        } else if status == .didCalculation {
            if let operation = operation, let operand = operand,
               let result = calculate(result: result, operation: operation, operand: operand){
                self.result = result
                view?.pushHistoryText(historyText + " \(operation) \(output) = \(String(format: "%g", result))\n")
                historyText = String(format: "%g", result)
                pushResult(result: self.result)
            }
        }
    }

    private func handleOperations(operationCharecter: String){
        switch status {
        case .typingFirstOperand, .didCalculation:
            if let result = Double(output) {
                self.result = result
                historyText = "\(output) "
            }
            operation = operationCharecter
            status = .waitForSecondOperand
        case .typingSecondOperand:
            if operationCharecter == "=" || operation != nil {
                guard let operand = Double(output), let operation = operation,
                      let result = calculate(result: result, operation: operation, operand: operand) else { break }
                view?.pushHistoryText(historyText + "\(operation) \(output) = \(String(format: "%g", result))\n")
                historyText = String(format: "%g", result)
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

//        view?.pushHistoryText("\(self.result) \(operation ?? "") = \(result)")

        self.result = result
        output = String(format: "%g", result)

        view?.setDisplayText(output)
    }
}
