//
//  HomeStatusView.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/28.
//

import Foundation
import UIKit

fileprivate enum StatusViewUnitType {
    case studyBooks
    case studyTotalWords
    case studyTodoWords
    
    case reviewBooks
    case reviewTotalWords
    case reviewTodoWords
    
    var titleText: String {
        switch self {
        case .studyBooks: return "학습 단어장"
        case .studyTotalWords: return "모든 학습"
        case .studyTodoWords: return "남은 학습"
        case .reviewBooks: return "복습 단어장"
        case .reviewTotalWords: return "모든 복습"
        case .reviewTodoWords: return "남은 복습"
        }
    }
}

class HomeStatusView: UIView {
    
    // MARK: Properties
    
    var homeStatus: HomeStatus? {
        didSet {
            configureStatus()
        }
    }
    
    private let studyBookUnit = HomeStatusViewUnit()
    private let studyWordUnit = HomeStatusViewUnit()
    private let studyTimeUnit = HomeStatusViewUnit()
    
    private let reviewBookUnit = HomeStatusViewUnit()
    private let reviewWordUnit = HomeStatusViewUnit()
    private let reviewTimeUnit = HomeStatusViewUnit()
    
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
    
    // MARK: Helpers
    
    private func configureUI() {
        
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
    
    private func configureUnits() {
        studyBookUnit.unitType = .studyBooks
        studyWordUnit.unitType = .studyTotalWords
        studyTimeUnit.unitType = .studyTodoWords
        
        reviewBookUnit.unitType = .reviewBooks
        reviewWordUnit.unitType = .reviewTotalWords
        reviewTimeUnit.unitType = .reviewTotalWords
    }
    
    private func configureStatus() {
        guard let homeStatus = homeStatus else { return }
        
        studyBookUnit.statString = "\(homeStatus.numOfStudyBooks)"
        studyWordUnit.statString = "\(homeStatus.numOfTotalStudyWords)단어"
        studyTimeUnit.statString = "\(homeStatus.numOfTodoStudyWords)단어"
        
        reviewBookUnit.statString = "\(homeStatus.numOfReviewBooks)"
        reviewWordUnit.statString = "\(homeStatus.numOfTotalReviewWords)단어"
        reviewTimeUnit.statString = "\(homeStatus.numOfTodoReviewWords)단어"
    }
    
}

fileprivate class HomeStatusViewUnit: UIView {
    
    // MARK: Properties
    
    var unitType: StatusViewUnitType? {
        didSet {
            configureNameLabel()
        }
    }
    
    var statString: String? {
        didSet {
            configureStat()
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        return label
    }()
    
    private let statLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
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
    
    private func configureUI() {
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
    
    private func configureNameLabel() {
        guard let unitType = unitType else { return }
        nameLabel.text = unitType.titleText
    }
    
    private func configureStat() {
        guard let statString = statString else { return }
        statLabel.text = statString
    }
}
