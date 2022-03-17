//
//  ListTestCell.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import UIKit

class TestListCell: UITableViewCell {
    
    // MARK: Properties
    
    var displayMode: WordListCellDisplayMode = .spelling {
        didSet {
            configure()
        }
    }
    
    var viewModel: TestListCellViewModel? {
        didSet {
            configure()
        }
    }
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
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
    
    // MARK: Selectors
    
    // MARK: Helpers
    
    func configureUI() {
        contentView.backgroundColor = UIColor.init(red: 255/256, green: 252/256, blue: 220/256, alpha: 1)
        contentView.layer.cornerRadius = (100 - 10) / 4
        
        // 최소 높이 100
        heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        self.layer.cornerRadius = 20
        
        addSubview(wordLabel)
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        wordLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    func configure() {
        if displayMode == .spelling {
            wordLabel.font = UIFont.systemFont(ofSize: 30)
            wordLabel.text = viewModel?.wordLabelText
        } else {
            wordLabel.font = UIFont.systemFont(ofSize: viewModel?.meaningFontSize ?? 10)
            wordLabel.text = viewModel?.meaningLabelText
        }
    }
    
    func toggleDisplayMode() {
        if displayMode == .spelling {
            displayMode = .meaning
        } else {
            displayMode = .spelling
        }
    }
    
}
