//
//  ViewController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/25.
//

import UIKit

private let reuseIdentifier = "HomeCell"

class HomeController: UIViewController {
    
    // MARK: Properties
    
    let statusView = HomeStatusView()
    
    let homeStatus = dummyHomeStatus
    
    let tableView = UITableView()
    
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureHomeStatusView()
    }
    
    // MARK: Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let statusViewHeight = view.frame.height * 0.2
        
        view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        statusView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        statusView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: statusViewHeight).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    func configureHomeStatusView() {
        statusView.homeStatus = dummyHomeStatus
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeStudyListCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension HomeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "학습 단어장"
        case 1: return "복습 단어장"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return homeStatus.numOfStudyBooks
        case 1: return homeStatus.numOfReviewBooks
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? HomeStudyListCell else { return UITableViewCell() }
        return cell
    }
}

extension HomeController: UITableViewDelegate {
    
}

