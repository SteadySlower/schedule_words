//
//  HomeListCell.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import UIKit

class HomeStudyListCell: UITableViewCell {
    
    // MARK: Properties
    
    var wordBook: WordBook? {
        didSet {
            tagCircle.date = wordBook?.createdAt
        }
    }
    
    private let tagCircle = HomeListCellCircle()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.sizeToFit()
        label.text = "1월 29일"
        return label
    }()
    
    private let numOfWordsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.sizeToFit()
        label.text = "30단어"
        return label
    }()
    
    private let numOfStudyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.sizeToFit()
        label.text = "3회독"
        return label
    }()
    
    // MARK: LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        self.selectionStyle = .none // 선택되었을 때 회색 배경이 생기지 않도록
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }

    
    // MARK: Helper
    
    private func configureUI() {
        contentView.backgroundColor = UIColor.init(red: 153/256, green: 204/256, blue: 255/256, alpha: 0.75)
        contentView.layer.cornerRadius = (100 - 10) / 4
        
        // 최소 높이 100
        heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        self.layer.cornerRadius = 20
        
        addSubview(tagCircle)
        tagCircle.translatesAutoresizingMaskIntoConstraints = false
        tagCircle.heightAnchor.constraint(equalToConstant: 80).isActive = true
        tagCircle.widthAnchor.constraint(equalTo: tagCircle.heightAnchor).isActive = true
        tagCircle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tagCircle.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: tagCircle.rightAnchor, constant: 20).isActive = true
        
        addSubview(numOfWordsLabel)
        numOfWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        numOfWordsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        numOfWordsLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15).isActive = true
        
        addSubview(numOfStudyLabel)
        numOfStudyLabel.translatesAutoresizingMaskIntoConstraints = false
        numOfStudyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        numOfStudyLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 15).isActive = true
    }
}

class HomeListCellCircle: UIView {
    
    // MARK: Properties
    
    var date: Date? {
        didSet {
            configureLabel()
        }
    }
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.sizeToFit()
        return label
    }()
    
    // MARK: LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    // MARK: Helper
    
    private func configureUI() {
        let length = frame.width
        layer.cornerRadius = length / 2
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 5
        
        addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func configureLabel() {
        guard let date = date else { return }
        let dateGap = Utilities().getDaysFromToday(date: date)
        
        switch dateGap {
        case 0:
            label.text = "오늘"
            layer.borderColor = UIColor.green.cgColor
            return
        case 1:
            label.text = "어제"
            layer.borderColor = UIColor.yellow.cgColor
            return
        case 2:
            label.text = "그제"
            layer.borderColor = UIColor.red.cgColor
            return
        default:
            label.text = "??"
            layer.borderColor = UIColor.black.cgColor
            return
        }
    }
}
