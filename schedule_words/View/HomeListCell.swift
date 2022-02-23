//
//  HomeListCell.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import UIKit

class HomeListCell: UITableViewCell {
    
    // MARK: Properties

    var viewModel: HomeCellViewModel? {
        didSet {
            tagCircle.viewModel = viewModel
            configureLabels()
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
        return label
    }()
    
    private let passRatioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.sizeToFit()
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
        
        addSubview(passRatioLabel)
        passRatioLabel.translatesAutoresizingMaskIntoConstraints = false
        passRatioLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        passRatioLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 15).isActive = true
    }
    
    private func configureLabels() {
        dateLabel.text = viewModel?.dateLabelString
        numOfWordsLabel.text = viewModel?.numOfWordsLabelString
        passRatioLabel.text = viewModel?.passRatioLabelString
    }
}

class HomeListCellCircle: UIView {
    
    // MARK: Properties
    
    var viewModel: HomeCellViewModel? {
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
        layer.borderWidth = 5
        
        addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func configureLabel() {
        tagLabel.text = viewModel?.tagCircleLabelString
        layer.borderColor = viewModel?.tagCircleColor
    }
}
