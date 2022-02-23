//
//  StudyListController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import UIKit

private let reuseIdentifier = "studyCell"

class StudyListController: UIViewController {
    
    // MARK: Properties
    
    var viewModel: StudyListViewModel
    
    let tableView = UITableView()
    
    let undoButton = FloatingUndoButton()
    
    // MARK: Lifecycle
    
    init(wordBook: WordBook) {
        self.viewModel = StudyListViewModel(wordBook: wordBook)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Selectors
    
    @objc
    
    // MARK: Helpers
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(undoButton)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        undoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StudyListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.selectionFollowsFocus = true
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
    }
    
    private func configureFloatingUndoButton() {
        // TODO: selector 만들고 연결
    }
}

// MARK: UITableViewDataSource

extension StudyListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? StudyListCell else { return UITableViewCell() }
        let word = viewModel.wordBook.words[indexPath.row]
        cell.viewModel = StudyListCellViewModel(word: word)
        return cell
    }
}

// MARK: UITableViewDelegate

extension StudyListController: UITableViewDelegate {
    // 터치시 단어 뜻이 보이도록
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indexPath로 cell 객체 구하기
        guard let cell = tableView.visibleCells.filter({ cell in
            let listCell = cell as! StudyListCell
            let word = listCell.viewModel!.word
            return word.id == self.viewModel.wordBook.words[indexPath.row].id
        }).first as? StudyListCell else { return }
        // cell 뒤집기
        UIView.transition(with: cell,
                    duration: 1,
                    options: .transitionFlipFromLeft,
                    animations: { return },
                    completion: nil)
        //카드 반 정도 돌아갔을 때 뜻으로 바꾸기
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.toggleDisplayMode()
       }
    }
}

