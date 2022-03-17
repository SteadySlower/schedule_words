//
//  TutorialPage5.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/17.
//

import Foundation
import UIKit

class TutorialPage5: UIView {
    
    // MARK: Properties
    
    let titleLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "단어 공부 하기 모드"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    lazy var imageView1: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Tutorial_image_4")
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: frame.width - 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 170).isActive = true
        return iv
    }()
    
    lazy var imageView2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Tutorial_image_5")
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: frame.width - 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 170).isActive = true
        return iv
    }()
    
    let contentLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "단어장의 학습하는 기능입니다. 각 단어를 터치하면 스펠링 / 뜻을 전환할 수 있습니다."
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
        
        addSubview(imageView2)
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView2.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 10).isActive = true
        imageView2.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        imageView2.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        addSubview(contentLabel1)
        contentLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentLabel1.topAnchor.constraint(equalTo: imageView2.bottomAnchor, constant: 10).isActive = true
        contentLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        contentLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
}

