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
        
        // ?????? ????????? ????????? ??? ????????? ??????
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(sender:)))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func showLongPressAlert(word: Word) {
        let title = word.spelling
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let editAction = UIAlertAction(title: "????????????", style: .default) { [weak self] _ in
            guard let weakSelf = self else { return }
            let edit = WordEditController(delegate: weakSelf, word: word)
            edit.modalPresentationStyle = .overFullScreen
            weakSelf.present(edit, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "????????????", style: .destructive) { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.deleteWord(word: word)
            weakSelf.resetData()
        }
        
        let cancelAction = UIAlertAction(title: "??????", style: .cancel, handler: nil)
        
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
    // ????????? ?????? ?????? ????????????
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indexPath??? cell ?????? ?????????
        guard let cell = tableView.visibleCells.filter({ cell in
            let listCell = cell as! StudyListCell
            let word = listCell.viewModel!.word
            return word.id == self.viewModel.displayingWords[indexPath.row].id
        }).first as? StudyListCell else { return }
        // cell ?????????
        UIView.transition(with: cell,
                    duration: 1,
                    options: .transitionFlipFromLeft,
                    animations: { return },
                    completion: nil)
        //?????? ??? ?????? ???????????? ??? ????????? ?????????
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

