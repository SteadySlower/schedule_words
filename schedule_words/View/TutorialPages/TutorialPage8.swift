//
//  TutorialPage8.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/17.
//

import Foundation
import UIKit

class TutorialPage8: UIView {
    
    // MARK: Properties
    
    let titleLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "단어장 옵션"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    
    lazy var imageView1: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Tutorial_image_9")
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: frame.width - 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 300).isActive = true
        return iv
    }()
    
    let contentLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "단어 보기: 테스트에 통과한 단어를 다시 학습/테스트 할 것인지 결정합니다.\n\n단어 순서: 학습/테스트할 때 단어를 추가한 순서대로 볼 것인지 혹은 랜덤 순서로 볼 것인지 결정합니다."
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
    }
}
