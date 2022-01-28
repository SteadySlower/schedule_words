//
//  HomeStatusView.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/28.
//

import Foundation
import UIKit

enum StatusViewUnitType {
    case studyBooks
    case studyWords
    case studyTime
    
    case reviewBooks
    case reviewWords
    case reviewTime
    
    var titleText: String {
        switch self {
        case .studyBooks: return "학습 단어장"
        case .studyWords: return "학습 단어"
        case .studyTime: return "학습 시간"
        case .reviewBooks: return "복습 단어장"
        case .reviewWords: return "복습 단어"
        case .reviewTime: return "복습 시간"
        }
    }
}

class HomeStatusView: UIView {
    
    // MARK: Properties
    
    let studyBookUnit = HomeStatusViewUnit()
    let studyWordUnit = HomeStatusViewUnit()
    let studyTimeUnit = HomeStatusViewUnit()
    
    let reviewBookUnit = HomeStatusViewUnit()
    let reviewWordUnit = HomeStatusViewUnit()
    let reviewTimeUnit = HomeStatusViewUnit()
    
    // MARK: LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUnits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureUI()
    }
    
    // MARK: Properties
    
    func configureUI() {
        
        layer.cornerRadius = frame.height * 0.25
        backgroundColor = UIColor.init(red: 255/256, green: 252/256, blue: 220/256, alpha: 1)
        
        let studyStackView = UIStackView(arrangedSubviews: [studyBookUnit, studyWordUnit, studyTimeUnit])
        studyStackView.axis = .horizontal
        studyStackView.distribution = .fillEqually
        
        let reviewStackView = UIStackView(arrangedSubviews: [reviewBookUnit, reviewWordUnit, reviewTimeUnit])
        reviewStackView.axis = .horizontal
        reviewStackView.distribution = .fillEqually
        
        let totalStackView = UIStackView(arrangedSubviews: [studyStackView, reviewStackView])
        totalStackView.axis = .vertical
        totalStackView.distribution = .fillEqually
        totalStackView.spacing = 8
        
        addSubview(totalStackView)
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        totalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        totalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        totalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
    
    func configureUnits() {
        studyBookUnit.unitType = .studyBooks
        studyWordUnit.unitType = .studyWords
        studyTimeUnit.unitType = .studyTime
        
        reviewBookUnit.unitType = .reviewBooks
        reviewWordUnit.unitType = .reviewWords
        reviewTimeUnit.unitType = .reviewTime
    }
    
}

class HomeStatusViewUnit: UIView {
    
    // MARK: Properties
    
    var unitType: StatusViewUnitType? {
        didSet {
            configureNameLabel()
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return label
    }()
    
    let statLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.text = "3" // 삭제
        return label
    }()
    
    // MARK: LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureUI()
    }
    
    // MARK: Properties
    
    func configureUI() {
        let nameLabelHeight = frame.height * 0.2
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabelHeight).isActive = true
        
        addSubview(statLabel)
        statLabel.translatesAutoresizingMaskIntoConstraints = false
        statLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        statLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: nameLabelHeight / 2).isActive = true
    }
    
    func configureNameLabel() {
        guard let unitType = unitType else { return }
        nameLabel.text = unitType.titleText
    }
}
