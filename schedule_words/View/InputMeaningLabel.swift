//
//  InputMeaningLabel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/02.
//

import UIKit

protocol InputMeaningLabelDelegate: AnyObject {
    func removeButtonTapped(sender: InputMeaningLabel)
}

class InputMeaningLabel: UIView {
    
    // MARK: Properties
    
    var index: Int?
    
    private var text: String {
        guard let index = index else { return "" }
        return "뜻\(index + 1): \(meaning ?? "")"
    }
    
    var meaning: String? {
        didSet {
            meaningLabel.text = self.text
            if meaning == nil {
                self.removeButton.isHidden = true
            } else {
                self.removeButton.isHidden = false
            }
        }
    }
    
    weak var delegate: InputMeaningLabelDelegate?
    
    private lazy var meaningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 25)
        label.text = self.text
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: LifeCycle
    
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
    
    // MARK: Selector
    
    @objc func removeButtonTapped() {
        delegate?.removeButtonTapped(sender: self)
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        let width = frame.width
        
        addSubview(meaningLabel)
        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        meaningLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        meaningLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        meaningLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        meaningLabel.widthAnchor.constraint(lessThanOrEqualToConstant: width * 0.8).isActive = true
        
        addSubview(removeButton)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        removeButton.leftAnchor.constraint(equalTo: meaningLabel.rightAnchor).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: width * 0.2).isActive = true
        
    }
}
