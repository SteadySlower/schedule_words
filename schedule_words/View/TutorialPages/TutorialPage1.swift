//
//  Tutorial_Page_1.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/16.
//

import Foundation
import UIKit

class TutorialPage1: UIView {
    
    // MARK: Properties
    
    let titleLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "스케줄 단어장 소개"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let contentLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "스케줄 단어장은 스케줄 기반의 단어 학습 앱입니다. 오늘 학습한 단어를 입력하면 효과적인 학습 및 복습 스케줄을 자동으로 수립하여 짧게 공부하고 오래 기억되는 단어 학습을 실현합니다."
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()
    
    let titleLabel2: UILabel = {
        let lb = UILabel()
        lb.text = "학습 및 복습 스케줄"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let contentLabel2: UILabel = {
        let lb = UILabel()
        lb.text = "스케줄 단어장이 추천하는 학습 및 복습 스케줄은 다음과 같습니다. 먼저 오늘 공부한 단어를 내일, 모레까지 총 3일간 학습합니다. 3일째 학습에서 테스트를 통과하지 못한 단어들은 다시 오늘 단어장으로 보내 3일간 다시 학습합니다."
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()
    
    let contentLabel3: UILabel = {
        let lb = UILabel()
        lb.text = "3일째 학습에 통과한 단어장은 복습 사이클로 넘어갑니다. 복습 사이클은 3일, 7일, 14일입니다. 복습 단어장의 테스트를 통과하지 못한 단어들은 다시 오늘 단어장으로 보내 처음부터 학습합니다."
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(titleLabel1)
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        titleLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        addSubview(contentLabel1)
        contentLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentLabel1.topAnchor.constraint(equalTo: titleLabel1.bottomAnchor, constant: 10).isActive = true
        contentLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        contentLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        addSubview(titleLabel2)
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.topAnchor.constraint(equalTo: contentLabel1.bottomAnchor, constant: 10).isActive = true
        titleLabel2.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        titleLabel2.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        addSubview(contentLabel2)
        contentLabel2.translatesAutoresizingMaskIntoConstraints = false
        contentLabel2.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor, constant: 10).isActive = true
        contentLabel2.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        contentLabel2.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        addSubview(contentLabel3)
        contentLabel3.translatesAutoresizingMaskIntoConstraints = false
        contentLabel3.topAnchor.constraint(equalTo: contentLabel2.bottomAnchor, constant: 10).isActive = true
        contentLabel3.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        contentLabel3.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
}
