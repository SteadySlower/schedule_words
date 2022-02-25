//
//  SettingController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/25.
//

import Foundation
import UIKit
import SideMenu

// 외부에서 사용할 컨트롤러 (SideMenu 여기서만 쓰게 캡슐)
class SettingContoller: SideMenuNavigationController {
    
    init() {
        super.init(rootViewController: _SettingController())
        self.leftSide = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let reuseIdentifier = "settingCell"

// 실제 내용을 정의하는 컨트롤러
private class _SettingController: UIViewController {
    
    // MARK: properties
    
    private let tableView = UITableView()
    
    private let viewModel = SettingViewModel()
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveSetting()
    }
    
    // MARK: Helpers
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30).isActive = true
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
    }
}

extension _SettingController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(of: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfRows(of: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? SettingCell else { return UITableViewCell() }
        cell.type = viewModel.typeForTestCell(of: indexPath)
        cell.delegate = self
        return cell
    }
}


extension _SettingController: SettingCellDelegate {
    func settingToggled(cell: SettingCell) {
        guard let type = cell.type else { return }
        viewModel.settingToggled(type: type)
    }
}
