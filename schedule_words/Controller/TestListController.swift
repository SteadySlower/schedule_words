//
//  TestListViewController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import UIKit

private let reuseIdentifier = "testCell"

class TestListController: UIViewController {
    
    // MARK: Properties
    
    var viewModel: TestListViewModel
    
    let scoreBoard = TestScoreBoard()
    
    let tableView = UITableView()
    
    lazy var undoButton: UIButton = {
        let button = UIButton(configuration: FLOATING_UNDO_BUTTON_CONFIGURATION, primaryAction: nil)
        button.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    
    init(wordBook: WordBook) {
        self.viewModel = TestListViewModel(wordBook: wordBook)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureScoreBoard()
        configureTableView()
        configureUndoButton()
    }
    
    // MARK: Selectors
    
    @objc func undoButtonTapped() {
        guard let index = viewModel.undo() else { return }
        configureScoreBoard()
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        configureUndoButton()
    }
    
    @objc func backNavigationButtonTapped() {
        viewModel.updateTestResult()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    private func configureUI() {
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
        
        view.addSubview(undoButton)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        undoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
    }
    
    private func configureNavigationBar() {
        let leftButton =  UIBarButtonItem(title: "< ?????????", style: .plain, target: self, action: #selector(backNavigationButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TestListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.selectionFollowsFocus = true
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
    }
    
    private func configureScoreBoard() {
        scoreBoard.scores = viewModel.scores
    }
    
    private func configureUndoButton() {
        undoButton.isHidden = viewModel.undoButtonIsHidden
    }
    
    private func showFinishAlert() {
        let alert = UIAlertController(title: "????????? ??????", message: "?????? ???????????? ?????? ???????????????.\n?????? ????????? ?????? ???????????? ?????? ????????? ?????? ??????????????? ???????????????.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "??????", style: .cancel, handler: nil)
        let finish = UIAlertAction(title: "????????? ??????", style: .destructive) { _ in
            self.viewModel.finishWordBook()
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(finish)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension TestListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfCells
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TestListCell else { return UITableViewCell() }
        let word = viewModel.displayingWords[indexPath.row]
        cell.viewModel = TestListCellViewModel(word: word)
        return cell
    }
}

// MARK: UITableViewDelegate

extension TestListController: UITableViewDelegate {
    // ????????? ?????? ?????? ????????????
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indexPath??? cell ?????? ?????????
        guard let cell = tableView.visibleCells.filter({ cell in
            let listCell = cell as! TestListCell
            let word = listCell.viewModel!.word
            return word.id == self.viewModel.displayingWords[indexPath.row].id
        }).first as? TestListCell else { return }
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
    
    // ????????? ????????????
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // viewModel?????? ???????????? ????????? ?????? word
        let word = viewModel.displayingWords[indexPath.row]
        
        // ???????????? ????????? ??? ????????? ??????
        let action = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel.moveWordToSuccess(success: word)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.configureScoreBoard()
            self.configureUndoButton()
            if self.viewModel.canFinish {
                self.showFinishAlert()
            }
            completionHandler(true)
        }
        
        // ??????????????? ??? ????????? ????????? ??????
        action.backgroundColor = .white
        
        // ?????? image??? ????????? ???????????? ???????????? ????????? ????????? ??????????????? ????????? ????????? ????????????
        // UIGraphicsImageRenderer??? ????????? ????????? ?????????
        // frame ?????? ???????????? ???????????? ?????? ????????? ????????????
        // ????????? ????????? ?????? cell ?????? ??????
        let imageSize = tableView.visibleCells.first?.bounds.height ?? 50
        
        action.image = UIGraphicsImageRenderer(size: CGSize(width: imageSize, height: imageSize)).image { _ in
            UIImage(systemName: "circle")!
                .withTintColor(.blue, renderingMode: .alwaysOriginal)
                .draw(in: CGRect(x: 7, y: 0, width: imageSize, height: imageSize))
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let word = viewModel.displayingWords[indexPath.row]

        let action = UIContextualAction(style: .normal, title: nil) { _, view, completionHandler in
            self.viewModel.moveWordToFail(fail: word)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.configureScoreBoard()
            self.configureUndoButton()
            if self.viewModel.canFinish {
                self.showFinishAlert()
            }
            completionHandler(true)
        }
        
        let imageSize = tableView.visibleCells.first?.bounds.height ?? 50
        action.backgroundColor = .white
        action.image = UIGraphicsImageRenderer(size: CGSize(width: imageSize, height: imageSize)).image { _ in
            UIImage(systemName: "multiply")!
                .withTintColor(.red, renderingMode: .alwaysOriginal)
                .draw(in: CGRect(x: -12, y: 0, width: imageSize, height: imageSize))
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: motionEnded (deprecated)

//// ????????? ?????? ??????
//extension TestListController {
//    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        if motion == .motionShake {
//            guard let index = viewModel.undo() else { return }
//            configureScoreBoard()
//            let indexPath = IndexPath(row: index, section: 0)
//            tableView.insertRows(at: [indexPath], with: .fade)
//        }
//    }
//}
