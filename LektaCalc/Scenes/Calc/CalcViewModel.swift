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
    func expressionTextFieldEditingChanged(text: String?)
}

class CalcViewModel {
    // MARK: - Properties
    private let calculateExpressionService: CalculateExpressionService
    private let resultRelay = PublishRelay<String>()
    private let alertMessageRelay = PublishRelay<String>()
    
    // MARK: - Initialization
    init(calculateExpressionService: CalculateExpressionService = CalculateExpressionServiceImpl()) {
        self.calculateExpressionService = calculateExpressionService
    }
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
    
    func expressionTextFieldEditingChanged(text: String?) {
        guard let strongText = text, !strongText.isEmpty else {
            resultRelay.accept("")
            return
        }
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
        DispatchQueue.global(qos: .utility).async { [weak self] in
            do {
                guard let value = try self?.calculateExpressionService.calculate(expression: text) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.resultRelay.accept(String(value))
                }
                
            } catch AppErrorException.runtimeException(let message) {
                DispatchQueue.main.async { [weak self] in
                    self?.alertMessageRelay.accept(message)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.alertMessageRelay.accept(error.localizedDescription)
                }
            }
        }
        
    }
    
}


