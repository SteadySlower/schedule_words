//
//  ListTestViewController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import UIKit

private let reuseIdentifier = "testCell"

class ListTestController: UIViewController {
    
    // MARK: Properties
    
    var viewModel = ListTestViewModel(wordBook: dummyWordBook)
        //🚫 dummy code
    
    let tableView = UITableView()
    let scoreBoard = TestScoreBoard()
    
    // MARK: Lifecycle
    
//    init(wordBook: WordBook) {
//        self.viewModel = listTestViewModel(wordBook: wordBook)
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureScoreBoard()
    }
    
    // MARK: Selectors
    
    // MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(scoreBoard)
        scoreBoard.translatesAutoresizingMaskIntoConstraints = false
        scoreBoard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scoreBoard.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scoreBoard.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scoreBoard.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: scoreBoard.bottomAnchor).isActive = true
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
        tableView.isUserInteractionEnabled = true
    }
    
    func configureScoreBoard() {
        scoreBoard.scores = viewModel.scores
    }

}

extension ListTestController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ListTestCell else { return UITableViewCell() }
        cell.word = viewModel.undefinedWords[indexPath.row]
        return cell
    }
}

extension ListTestController: UITableViewDelegate {
    // 커스텀 스와이프
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let word = viewModel.undefinedWords[indexPath.row]
        let action = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel.moveWordToSuccess(word: word)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        action.backgroundColor = .white
        action.image = UIImage(systemName: "circle")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let word = viewModel.undefinedWords[indexPath.row]
        let action = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel.moveWordToFail(word: word)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        action.backgroundColor = .white
        action.image = UIImage(systemName: "multiply")
        return UISwipeActionsConfiguration(actions: [action])
    }
}
