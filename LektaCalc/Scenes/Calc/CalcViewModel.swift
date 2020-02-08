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
    private let resultRelay = PublishRelay<String>()
    private let alertMessageRelay = PublishRelay<String>()
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
            
        } else {
            alertMessageRelay.accept(Strings.Calc.shouldContainOnlyCharacters.localized)
        }
    }
}
