//
//  TestScoreBoradView.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation
import UIKit

class ScoreUnit: UIView {
    
    // MARK: Properties
    
    var image: UIImage? {
        didSet {
            configureImageView()
        }
    }
    var score: Int? {
        didSet {
            configureScoreLabel()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return iv
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.widthAnchor.constraint(equalToConstant: 30).isActive = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let underBar: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    // MARK: LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [imageView, scoreLabel])
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 20
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(underBar)
        underBar.translatesAutoresizingMaskIntoConstraints = false
        underBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underBar.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        underBar.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
    }
    
    private func configureImageView() {
        imageView.image = image
    }
    
    private func configureScoreLabel() {
        scoreLabel.text = "\(score ?? 0) 단어"
    }
}

class TestScoreBoard: UIView {
    var scores: (undefined: Int, success: Int, fail: Int)? {
        didSet {
            self.undefinedScoreUnit.score = scores?.undefined ?? 0
            self.successScoreUnit.score = scores?.success ?? 0
            self.failScoreUnit.score = scores?.fail ?? 0
        }
    }
    
    private let undefinedScoreUnit = ScoreUnit()
    private let successScoreUnit = ScoreUnit()
    private let failScoreUnit = ScoreUnit()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        undefinedScoreUnit.image = UIImage(systemName: "character.book.closed")
        successScoreUnit.image = UIImage(systemName: "circle")
        failScoreUnit.image = UIImage(systemName: "multiply")
        
        let stack = UIStackView(arrangedSubviews: [undefinedScoreUnit, successScoreUnit, failScoreUnit])
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 30
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
}
