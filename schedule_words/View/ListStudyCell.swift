//
//  ListStudyCell.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import UIKit

protocol ListStudyCellDelegate: AnyObject {
    func boxChecked(word: Word)
    func boxUnchecked(word: Word)
}

class ListStudyCell: UITableViewCell {
    
    // MARK: Properties
    
    var displayMode: WordListCellDisplayMode = .spelling {
        didSet {
            configure()
        }
    }
    
    var viewModel: ListStudyCellViewModel? {
        didSet {
            configure()
        }
    }
    
    var delegate: ListStudyCellDelegate?
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let checkBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        return button
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        displayMode = .spelling
    }
    
    // MARK: Selectors
    
    @objc func checkBoxTapped() {
        guard let word = viewModel?.word else { return }
        
        if checkBox.isSelected == true {
            delegate?.boxUnchecked(word: word)
        } else {
            delegate?.boxChecked(word: word)
        }
    }
    
    // MARK: Helpers
    
    func configureUI() {
        contentView.backgroundColor = UIColor.init(red: 255/256, green: 252/256, blue: 220/256, alpha: 1)
        contentView.layer.cornerRadius = (100 - 10) / 4
        
        // 최소 높이 100
        heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        self.layer.cornerRadius = 20
        
        addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkBox.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        addSubview(wordLabel)
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        wordLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo:checkBox.rightAnchor).isActive = true
    }

    func configure() {
        if displayMode == .spelling {
            wordLabel.font = UIFont.systemFont(ofSize: 30)
            wordLabel.text = viewModel?.wordLabelText
        } else {
            var fontSize: CGFloat
            
            switch viewModel?.word.meanings.count {
            case 1: fontSize = 30
            case 2: fontSize = 20
            case 3: fontSize = 15
            default: fontSize = 10
            }
            
            wordLabel.font = UIFont.systemFont(ofSize: fontSize)
            wordLabel.text = viewModel?.meaningLabelText
        }
        
        checkBox.isSelected = viewModel?.checkBoxIsSelected ?? false
    }
    
    func toggleDisplayMode() {
        if displayMode == .spelling {
            displayMode = .meaning
        } else {
            displayMode = .spelling
        }
    }
    
}
