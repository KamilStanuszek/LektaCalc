//
//  CalcViewController.swift
//  LektaCalc
//
//  Created by Kamil Stanuszek on 08/02/2020.
//  Copyright © 2020 Kamil Stanuszek. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController {
    //MARK: - Properties
    let viewModel: CalcViewModelLogic = CalcViewModel()
    
    // MARK: - Views
    @IBOutlet weak var expressionTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var executeButton: UIButton!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresentationLogic()
    }

}

// MARK: - Private methods
extension CalcViewController {
    private func setupPresentationLogic() {
        setupClosingKeyboardOnTapingAnywhere()
        setupViews()
    }
    
    private func setupClosingKeyboardOnTapingAnywhere() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupViews() {
        executeButton.addTarget(self, action: #selector(executeButtonClicked), for: .touchUpInside)
    }
    
    @objc func executeButtonClicked() {
        guard let expression = expressionTextField.text else { return }
        viewModel.executeButtonClicked(expressionText: expression)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

