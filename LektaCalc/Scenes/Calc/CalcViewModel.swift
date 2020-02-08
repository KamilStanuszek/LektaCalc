//
//  CalcViewModel.swift
//  LektaCalc
//
//  Created by Kamil Stanuszek on 08/02/2020.
//  Copyright © 2020 Kamil Stanuszek. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CalcViewModelLogic {
    var resultObs: Observable<String> { get }
    var alertMessageObs: Observable<String> { get }
    func executeButtonClicked(expressionText: String)
}

class CalcViewModel {
    // MARK: - Properties
    private let resultRelay = PublishRelay<String>()
    private let alertMessageRelay = PublishRelay<String>()
    
    var allCharacters: [Character] = []
    var values: [Int] = []
    var operators: [Character] = []
    var index = 0
}

// MARK: - CalcViewModelLogic
extension CalcViewModel: CalcViewModelLogic {
    var alertMessageObs: Observable<String> {
        return alertMessageRelay.asObservable()
    }
    
    var resultObs: Observable<String> {
        return resultRelay.asObservable()
    }
    
    func executeButtonClicked(expressionText: String) {
        checkCharacters(expressionText)
    }
}

// MARK: - Private methods
extension CalcViewModel {
    private func checkCharacters(_ text: String) {
        if text.hasOnlyMathematicCharacters {
            tryCalculate(text: text)
        } else {
            alertMessageRelay.accept(Strings.Calc.shouldContainOnlyCharacters.localized)
        }
    }
    
    private func tryCalculate(text: String) {
        do {
            guard let value = try calculate(expression: text) else { return }
            resultRelay.accept(String(value))
        } catch AppErrorException.runtimeException(let message) {
            alertMessageRelay.accept(message)
        } catch {
            alertMessageRelay.accept(error.localizedDescription)
        }
    }
    
    private func calculate(expression: String) throws -> Int? {
        allCharacters = Array(expression)
        index = 0
        values.removeAll()
        operators.removeAll()
        
        while index < allCharacters.count {
            if allCharacters[index].isNumber {
                doAlgorithmForNumber()
            } else if allCharacters[index] == "(" {
                operators.append(allCharacters[index])
            } else if allCharacters[index] == ")" {
                try doAlgorithmForClosedParenthesis()
            } else if allCharacters[index].isOperator {
                try doAlgorithmForOperator()
            }
            index += 1
        }
            
        while !operators.isEmpty {
            guard operators.last != nil, values.count >= 2 else {
                throw AppErrorException.runtimeException(message: Strings.Calc.Exceptions.expressionNotCorrect.localized)
            }
            values.append(try calcSimpleExpression(
                operator: operators.popLast()!,
                values.popLast()!,
                values.popLast()!
            ))
        }
        return values.last;
    }
    
    private func calcSimpleExpression(operator: Character, _ firstValue: Int, _ secondValue: Int) throws -> Int {
        switch `operator` {
        case "+":
            return secondValue + firstValue
        case "-":
            return secondValue - firstValue
        case "*":
            return secondValue * firstValue
        case "/":
            guard firstValue != 0 else {
                throw AppErrorException.runtimeException(message: Strings.Calc.Exceptions.couldNotDivideByZero.localized)
            }
            return secondValue / firstValue
        default:
            return 0
        }
    }
    
    private func doAlgorithmForNumber() {
        var valueString: [Character] = []
        while index < allCharacters.count, allCharacters[index].isNumber {
            valueString.append(allCharacters[index])
            index += 1
        }
        index -= 1
        values.append(Int(String(valueString))!)
    }
    
    private func doAlgorithmForClosedParenthesis() throws {
        while operators.last != "(" {
            guard operators.last != nil, values.count >= 2 else {
                throw AppErrorException.runtimeException(message: Strings.Calc.Exceptions.expressionNotCorrect.localized)
            }
            values.append(try calcSimpleExpression(
                operator: operators.popLast()!,
                values.popLast()!,
                values.popLast()!
            ))
        }
        operators.removeLast()
    }
    
    private func doAlgorithmForOperator() throws {
        while !operators.isEmpty, operators.last!.isPrior(than: allCharacters[index]) {
            guard operators.last != nil, values.count >= 2 else {
                throw AppErrorException.runtimeException(message: Strings.Calc.Exceptions.expressionNotCorrect.localized)
            }
            values.append(try calcSimpleExpression(
                operator: operators.popLast()!,
                values.popLast()!,
                values.popLast()!
            ))
        }
        operators.append(allCharacters[index])
    }
    
}

fileprivate extension Character {
    func isPrior(than operator: Character) -> Bool {
        if self.isParenthesis { return false }
        if (`operator` == "*" || `operator` == "/") && (self == "+" || self == "-") { return false }
        return true
    }
    
    var isParenthesis: Bool {
        return self == "(" || self == ")"
    }
    
    var isOperator: Bool {
        return self == "+" || self == "-" || self == "*" || self == "/"
    }
}
