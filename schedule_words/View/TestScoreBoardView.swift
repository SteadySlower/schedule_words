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
    
    var image: UIImage?
    var score: Int? {
        didSet {
            configureScoreLabel()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: LifeCycle
    
    // MARK: Helpers
    
    func configureUI() {
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        addSubview(scoreLabel)
        scoreLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
    }
    
    func configureImageView() {
        imageView.image = image
    }
    
    func configureScoreLabel() {
        scoreLabel.text = String(describing: score)
    }
}

class TestScoreBoard: UIView {
    var toGoScore: Int?
    var successScore: Int?
    var failScore: Int?
    
    let toGoScoreUnit = ScoreUnit()
    let successScoreUnit = ScoreUnit()
    let failScoreUnit = ScoreUnit()
    
    func configureUI() {
        
    }
}
