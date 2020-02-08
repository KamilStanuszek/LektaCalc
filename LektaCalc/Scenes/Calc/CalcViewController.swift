//
//  CalcViewController.swift
//  LektaCalc
//
//  Created by Kamil Stanuszek on 08/02/2020.
//  Copyright © 2020 Kamil Stanuszek. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CalcViewController: UIViewController {
    //MARK: - Properties
    let viewModel: CalcViewModelLogic = CalcViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Views
    @IBOutlet weak var expressionTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var executeButton: UIButton!
    
    // MARK: - Actions
    @IBAction func expressionTextFieldEditingChanged(_ sender: UITextField) {
        viewModel.expressionTextFieldEditingChanged(text: sender.text)
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
        setupPresentationLogic()
    }

}

// MARK: - Private methods
extension CalcViewController {
    private func observeViewModel() {
        viewModel.alertMessageObs
            .subscribe(onNext: { [unowned self] message in
                self.createAlert(title: Strings.Calc.expressionError.localized, message: message)
            }).disposed(by: disposeBag)
        
        viewModel.resultObs
            .subscribe(onNext: { [unowned self] result in
                self.resultLabel.text = result
            }).disposed(by: disposeBag)
    }
    
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
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak alert] _ in
            alert?.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
    @objc func executeButtonClicked() {
        guard let expression = expressionTextField.text else { return }
        viewModel.executeButtonClicked(expressionText: expression)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

