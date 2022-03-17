//
//  TutorialPage2.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/16.
//

import Foundation
import UIKit

class TutorialPage2: UIView {
    
    // MARK: Properties
    
    let titleLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "홈화면 소개"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    lazy var imageView1: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Tutorial_image_1")
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: frame.width - 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return iv
    }()
    
    let contentLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "오늘 학습 및 복습할 단어장, 모든 단어, 남은 단어의 갯수를 볼 수 있습니다. 남은 단어는 테스트를 아직 통과하지 못한 단어들을 의미합니다."
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()
    
    let contentLabel2: UILabel = {
        let lb = UILabel()
        lb.text = "⚙️: 설정하기\n❓: 튜토리얼 보기\n➕: 단어 추가"
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(titleLabel1)
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        titleLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        addSubview(imageView1)
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.topAnchor.constraint(equalTo: titleLabel1.bottomAnchor, constant: 10).isActive = true
        imageView1.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        imageView1.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        addSubview(contentLabel1)
        contentLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentLabel1.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 10).isActive = true
        contentLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        contentLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        addSubview(contentLabel2)
        contentLabel2.translatesAutoresizingMaskIntoConstraints = false
        contentLabel2.topAnchor.constraint(equalTo: contentLabel1.bottomAnchor, constant: 10).isActive = true
        contentLabel2.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        contentLabel2.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
}

