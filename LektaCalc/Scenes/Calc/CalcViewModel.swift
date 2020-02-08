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
    func executeButtonClicked(expressionText: String)
}

class CalcViewModel {
    private let resultRelay = PublishRelay<String>()
}

// MARK: - CalcViewModelLogic
extension CalcViewModel: CalcViewModelLogic {
    var resultObs: Observable<String> {
        return resultRelay.asObservable()
    }
    
    func executeButtonClicked(expressionText: String) {
        
    }
}
