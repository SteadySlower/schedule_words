//
//  ListTestViewController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import UIKit

private let reuseIdentifier = "testCell"

class ListTestViewController: UIViewController {
    
    // MARK: Properties
    
    let tableView = UITableView()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    // MARK: Selectors
    
    // MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTestCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }

}

extension ListTestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ListTestCell else { return UITableViewCell() }
        return cell
    }
}

extension ListTestViewController: UITableViewDelegate {
    
}
