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
    
    @objc func cellLongPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.tableView)
            
            guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return }
            guard let cell = tableView.cellForRow(at: indexPath) as? StudyListCell else { return }
            
            guard let word = cell.viewModel?.word else { return }
            
            showLongPressAlert(word: word)
        }
    }
    
    // MARK: Helpers
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StudyListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.selectionFollowsFocus = true
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        
        // 길게 누르면 수정할 수 있도록 세팅
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(sender:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func showLongPressAlert(word: Word) {
        let title = word.spelling
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
            guard let weakSelf = self else { return }
            let edit = WordEditController(delegate: weakSelf, word: word)
            edit.modalPresentationStyle = .overFullScreen
            weakSelf.present(edit, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.deleteWord(word: word)
            weakSelf.resetData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension StudyListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? StudyListCell else { return UITableViewCell() }
        let word = viewModel.displayingWords[indexPath.row]
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
            return word.id == self.viewModel.displayingWords[indexPath.row].id
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

// MARK: WordEditControllerDelegate

extension StudyListController: WordEditControllerDelegate {
    func resetData() {
        viewModel.resetDisplayWords()
        tableView.reloadData()
    }
}

