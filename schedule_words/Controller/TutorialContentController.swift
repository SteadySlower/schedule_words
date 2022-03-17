//
//  TutorialPage1.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/16.
//

import UIKit

class TutorialContentController: UIViewController {
    
    var contentView: UIView
    
    init(pageNumber: Int) {
        switch pageNumber {
        case 1: self.contentView = TutorialPage1()
        case 2: self.contentView = TutorialPage2()
        case 3: self.contentView = TutorialPage3()
        case 4: self.contentView = TutorialPage4()
        case 5: self.contentView = TutorialPage5()
        case 6: self.contentView = TutorialPage6()
        case 7: self.contentView = TutorialPage7()
        case 8: self.contentView = TutorialPage8()
        default: self.contentView = UIView()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }

}
