//
//  WordInputController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/01.
//

import UIKit

class WordInputController: UIViewController {
    
    // MARK: Properties
    
    private var meanings = [String]()
    
    private let inputBox: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 0/256, green: 100/256, blue: 0/256, alpha: 0.5)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerInput), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 220/256, green: 20/256, blue: 60/256, alpha: 0.5)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelInput), for: .touchUpInside)
        return button
    }()
    
    private lazy var wordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "단어를 입력하세요."
        tf.borderStyle = .roundedRect
        tf.adjustsFontSizeToFitWidth = true
        tf.addTarget(self, action: #selector(wordTextFieldValueChanged(sender:)), for: .editingChanged)
        tf.autocapitalizationType = .none
        tf.becomeFirstResponder()
        tf.delegate = self
        return tf
    }()
    
    private lazy var meaningTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "뜻을 추가하세요."
        tf.borderStyle = .roundedRect
        tf.adjustsFontSizeToFitWidth = true
        tf.autocapitalizationType = .none
        tf.delegate = self
        return tf
    }()
    
    private let meaningAddingButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = UIColor(red: 0/256, green: 206/256, blue: 209/256, alpha: 0.5)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addMeaningTapped), for: .touchUpInside)
        return button
    }()
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 25)
        label.text = "단어: "
        label.sizeToFit()
        return label
    }()
    
    private lazy var firstInputMeaningLabel: InputMeaningLabel = {
        let lb = InputMeaningLabel()
        lb.index = 0
        lb.delegate = self
        return lb
    }()
    
    private lazy var secondInputMeaningLabel: InputMeaningLabel = {
        let lb = InputMeaningLabel()
        lb.index = 1
        lb.delegate = self
        return lb
    }()
    
    private lazy var thirdInputMeaningLabel: InputMeaningLabel = {
        let lb = InputMeaningLabel()
        lb.index = 2
        lb.delegate = self
        return lb
    }()
    
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        configureUI()
    }
    
    // MARK: Selector
    
    @objc private func registerInput() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelInput() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func wordTextFieldValueChanged(sender: UITextField) {
        guard let word = sender.text else { return }
        wordLabel.text = "단어: \(word)"
    }
    
    @objc private func addMeaningTapped() {
        // 에러: 뜻이 이미 3개 이상일 때
        if meanings.count >= 3 {
            showErrorAlert(error: .tooManyMeanings)
            return
        }
        
        // 에러: 한글이 아닌 뜻을 입력할 때
        guard let meaning = meaningTextField.text else { return }
        guard meaning != "" else { return }
        guard Utilities().validateMeaningInput(input: meaning) == true else {
            showErrorAlert(error: .meaningValidationFailure)
            return
        }
        
        meanings.append(meaning)
        meaningTextField.text = ""
        configureMeaningLabels()
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        view.backgroundColor = UIColor(displayP3Red: 0/256, green: 0/256, blue: 0/256, alpha: 0.5)
        
        let inputBoxWidth = view.frame.width * 0.75
        let inputBoxHeight = view.frame.height * 0.5
        
        view.addSubview(inputBox)
        inputBox.translatesAutoresizingMaskIntoConstraints = false
        inputBox.widthAnchor.constraint(equalToConstant: inputBoxWidth).isActive = true
        inputBox.heightAnchor.constraint(equalToConstant: inputBoxHeight).isActive = true
        inputBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true

        view.addSubview(wordTextField)
        wordTextField.translatesAutoresizingMaskIntoConstraints = false
        wordTextField.widthAnchor.constraint(equalToConstant: inputBoxWidth - 30).isActive = true
        wordTextField.heightAnchor.constraint(equalToConstant: inputBoxHeight * 0.12).isActive = true
        wordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wordTextField.topAnchor.constraint(equalTo: inputBox.topAnchor, constant: 10).isActive = true
        
        view.addSubview(meaningTextField)
        meaningTextField.translatesAutoresizingMaskIntoConstraints = false
        meaningTextField.widthAnchor.constraint(equalToConstant: (inputBoxWidth - 30) * 0.8 - 2.5).isActive = true
        meaningTextField.heightAnchor.constraint(equalToConstant: inputBoxHeight * 0.12).isActive = true
        meaningTextField.leftAnchor.constraint(equalTo: wordTextField.leftAnchor).isActive = true
        meaningTextField.topAnchor.constraint(equalTo: wordTextField.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(meaningAddingButton)
        meaningAddingButton.translatesAutoresizingMaskIntoConstraints = false
        meaningAddingButton.widthAnchor.constraint(equalToConstant: (inputBoxWidth - 30) * 0.2 - 2.5).isActive = true
        meaningAddingButton.heightAnchor.constraint(equalToConstant: inputBoxHeight * 0.12).isActive = true
        meaningAddingButton.rightAnchor.constraint(equalTo: wordTextField.rightAnchor).isActive = true
        meaningAddingButton.topAnchor.constraint(equalTo: wordTextField.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(wordLabel)
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.widthAnchor.constraint(lessThanOrEqualToConstant: (inputBoxWidth - 30) * 0.8 - 2.5).isActive = true
        wordLabel.heightAnchor.constraint(equalToConstant: inputBoxHeight * 0.10).isActive = true
        wordLabel.leftAnchor.constraint(equalTo: wordTextField.leftAnchor).isActive = true
        wordLabel.topAnchor.constraint(equalTo: meaningTextField.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(firstInputMeaningLabel)
        firstInputMeaningLabel.translatesAutoresizingMaskIntoConstraints = false
        firstInputMeaningLabel.widthAnchor.constraint(equalToConstant: (inputBoxWidth - 30) * 0.8).isActive = true
        firstInputMeaningLabel.heightAnchor.constraint(equalToConstant: inputBoxHeight * 0.10).isActive = true
        firstInputMeaningLabel.leftAnchor.constraint(equalTo: wordTextField.leftAnchor).isActive = true
        firstInputMeaningLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(secondInputMeaningLabel)
        secondInputMeaningLabel.translatesAutoresizingMaskIntoConstraints = false
        secondInputMeaningLabel.widthAnchor.constraint(equalToConstant: (inputBoxWidth - 30) * 0.8).isActive = true
        secondInputMeaningLabel.heightAnchor.constraint(equalToConstant: inputBoxHeight * 0.10).isActive = true
        secondInputMeaningLabel.leftAnchor.constraint(equalTo: wordTextField.leftAnchor).isActive = true
        secondInputMeaningLabel.topAnchor.constraint(equalTo: firstInputMeaningLabel.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(thirdInputMeaningLabel)
        thirdInputMeaningLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdInputMeaningLabel.widthAnchor.constraint(equalToConstant: (inputBoxWidth - 30) * 0.8).isActive = true
        thirdInputMeaningLabel.heightAnchor.constraint(equalToConstant: inputBoxHeight * 0.10).isActive = true
        thirdInputMeaningLabel.leftAnchor.constraint(equalTo: wordTextField.leftAnchor).isActive = true
        thirdInputMeaningLabel.topAnchor.constraint(equalTo: secondInputMeaningLabel.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.widthAnchor.constraint(equalToConstant: inputBoxWidth * 0.5 - 30).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(inputBoxWidth * 0.25 - 10)).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: inputBox.bottomAnchor, constant: -10).isActive = true

        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: inputBoxWidth * 0.5 - 30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: (inputBoxWidth * 0.25 - 10)).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: inputBox.bottomAnchor, constant: -10).isActive = true
    }
    
    private func configureMeaningLabels() {
        var meaningsSlice = meanings[meanings.indices]
        
        let firstMeaning = meaningsSlice.popFirst()
        let secondMeaning = meaningsSlice.popFirst()
        let thirdMeaning = meaningsSlice.popFirst()
        
        firstInputMeaningLabel.meaning = firstMeaning
        secondInputMeaningLabel.meaning = secondMeaning
        thirdInputMeaningLabel.meaning = thirdMeaning
    }
    
    private func showErrorAlert(error: WordInputError) {
        let alert = UIAlertController(title: "에러", message: error.message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: InputMeaningLabelDelegate

extension WordInputController: InputMeaningLabelDelegate {
    func removeButtonTapped(sender: InputMeaningLabel) {
        guard let index = sender.index else { return }
        meanings.remove(at: index)
        configureMeaningLabels()
    }
}

// MARK: UITextFieldDelegate

extension WordInputController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == wordTextField {
            textField.resignFirstResponder()
            meaningTextField.becomeFirstResponder()
        } else if textField == meaningTextField {
            self.addMeaningTapped()
        }
        return true
    }
}
