//
//  ViewController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/25.
//

import UIKit

class HomeController: UIViewController {
    
    let statusView = HomeStatusView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        let statusViewHeight = view.frame.height * 0.2
        
        view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        statusView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        statusView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: statusViewHeight).isActive = true
    }
}

