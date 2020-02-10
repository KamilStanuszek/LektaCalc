//
//  CalculateExpressionService.swift
//  LektaCalc
//
//  Created by Kamil Stanuszek on 08/02/2020.
//  Copyright © 2020 Kamil Stanuszek. All rights reserved.
//

import Foundation

protocol CalculateExpressionService {
    func calculate(expression: String) throws -> Float?
}

final class CalculateExpressionServiceImpl: CalculateExpressionService {
    // MARK: - Properies
    private var allCharacters: [Character] = []
    private var values: [Float] = []
    private var operators: [Character] = []
    private var index = 0
    private var itIsNegativeNumer: Bool {
        return (allCharacters[index] == "-" && index > 0 && allCharacters[index - 1] == "(") ||
        (allCharacters[index] == "-" && index == 0)
    }
    
    func calculate(expression: String) throws -> Float? {
        allCharacters = Array(expression)
        index = 0
        values.removeAll()
        operators.removeAll()
        
        while index < allCharacters.count {
            if allCharacters[index].isNumberOrDot {
                try doAlgorithmForNumber()
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
        guard values.count == 1 else {
            throw AppErrorException.runtimeException(message: Strings.Calc.Exceptions.expressionNotCorrect.localized)
        }
        return values.first;
    }
}
    
// MARK: - Private methods
extension CalculateExpressionServiceImpl {
    private func calcSimpleExpression(operator: Character, _ firstValue: Float, _ secondValue: Float) throws -> Float {
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
    
    private func doAlgorithmForNumber() throws {
        var valueString: [Character] = []
        while index < allCharacters.count, allCharacters[index].isNumberOrDot {
            valueString.append(allCharacters[index])
            index += 1
        }
        index -= 1
        guard let number = Float(String(valueString)) else {
            throw AppErrorException.runtimeException(message: Strings.Calc.Exceptions.oneOfNumersIsTooLong.localized)
        }
        values.append(number)
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
        if itIsNegativeNumer {
            values.append(-1)
            allCharacters[index] = "*"
        }
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

// MARK: - Character extension
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
    
    var isNumberOrDot: Bool {
        return self.isNumber || self == "."
    }
}
