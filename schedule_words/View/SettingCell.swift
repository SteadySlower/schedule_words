//
//  SettingCell.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/25.
//

import Foundation
import UIKit

protocol SettingCellDelegate: AnyObject {
    func settingToggled(cell: SettingCell)
}

class SettingCell: UITableViewCell {
    
    // MARK: Properties
    
    var type: SettingType? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: SettingCellDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let sg = UISegmentedControl(items: type?.segmentItems)
        sg.addTarget(self, action: #selector(segmentValueChanged(sender:)), for: .valueChanged)
        return sg
    }()
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    // MARK: Selectors
    
    @objc func segmentValueChanged(sender: UISegmentedControl) {
        delegate?.settingToggled(cell: self)
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        let cellWidth = frame.width
        let cellHeight = frame.height
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: cellWidth * 0.3 - 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: cellHeight * 0.8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.widthAnchor.constraint(equalToConstant: cellWidth * 0.6 - 5).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: cellHeight * 0.8).isActive = true
        segmentControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
    }
    
    private func configure() {
        titleLabel.text = type?.description
        segmentControl.selectedSegmentIndex = (type?.selectedSegmentIndex)!
    }
}
