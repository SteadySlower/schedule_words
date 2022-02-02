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
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureHomeStatusView()
    }
    
    // MARK: Selectors
    
    @objc func showWordInputController() {
        let input = WordInputController()
        input.modalPresentationStyle = .overFullScreen
        self.present(input, animated: true, completion: nil)
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
        tableView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 5).isActive = true
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
        tableView.register(HomeListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "홈화면"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "추가", style: .plain, target: self, action: #selector(showWordInputController))
    }
    
    func showActionSheet(cell: HomeListCell) {
        guard let wordBook = cell.viewModel?.wordBook else { return }
        guard let actionSheetTitle = cell.viewModel?.actionSheetTitle else { return }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .heavy), NSAttributedString.Key.foregroundColor: UIColor.blue]
        let titleAttrString = NSMutableAttributedString(string: actionSheetTitle, attributes: attributes)
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        let studyAction = UIAlertAction(title: "공부 하기", style: .default) { _ in
            let studyController = ListStudyController(wordBook: wordBook)
            self.navigationController?.pushViewController(studyController, animated: true)
        }
        let testAction = UIAlertAction(title: "테스트 하기", style: .default) { _ in
            let testController = ListTestController(wordBook: wordBook) //🚫 study용 컨트롤러로 수정하기
            self.navigationController?.pushViewController(testController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        actionSheet.addAction(studyAction)
        actionSheet.addAction(testAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension HomeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "오늘 공부할 단어장"
        case 1: return "오늘 복습할 단어장"
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? HomeListCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            let wordBook = homeStatus.studyWordBooks[indexPath.row]
            cell.viewModel = HomeCellViewModel(wordBook: wordBook)
        } else if indexPath.section == 1 {
            let wordBook = homeStatus.reviewWordBooks[indexPath.row]
            cell.viewModel = HomeCellViewModel(wordBook: wordBook)
        }
        return cell
    }
}

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let cell = tableView.cellForRow(at: indexPath) as? HomeListCell else { return }
            showActionSheet(cell: cell)
        } else if indexPath.section == 1 {
            guard let cell = tableView.cellForRow(at: indexPath) as? HomeListCell else { return }
            showActionSheet(cell: cell)
        }
    }
}

