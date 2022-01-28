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
        tableView.selectionFollowsFocus = true
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
    // 터치시 단어 뜻이 보이도록
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indexPath로 cell 객체 구하기
        guard let cell = tableView.visibleCells.filter({ cell in
            let listCell = cell as! ListTestCell
            return listCell.word!.id == self.viewModel.undefinedWords[indexPath.row].id
        }).first as? ListTestCell else { return }
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
    
    // 커스텀 스와이프
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 이미지 크기를 위한 cell 크기 재기
        let imageSize = tableView.visibleCells.first?.bounds.height ?? 50
        
        // viewModel에서 처리하기 위해서 해당 word
        let word = viewModel.undefinedWords[indexPath.row]
        
        // 스와이프 되었을 때 실행할 동작
        let action = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel.moveWordToSuccess(word: word)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.configureScoreBoard()
            completionHandler(true)
        }
        
        // 스와이프할 때 나오는 아이콘 수정
        action.backgroundColor = .white
        
        // 그냥 image만 넣으면 흰색으로 자동으로 랜더링 되므로 색변경하고 랜더링 안되게 오리지널
        // UIGraphicsImageRenderer를 통해서 사이즈 키우고
        // frame 위치 조정해서 이미지가 중간 정도에 보이도록
        action.image = UIGraphicsImageRenderer(size: CGSize(width: imageSize, height: imageSize)).image { _ in
            UIImage(systemName: "circle")!
                .withTintColor(.blue, renderingMode: .alwaysOriginal)
                .draw(in: CGRect(x: 7, y: 0, width: imageSize, height: imageSize))
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let word = viewModel.undefinedWords[indexPath.row]
        let imageSize = tableView.visibleCells.first?.bounds.height ?? 50
        let action = UIContextualAction(style: .normal, title: nil) { _, view, completionHandler in
            self.viewModel.moveWordToFail(word: word)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.configureScoreBoard()
            completionHandler(true)
        }
        
        action.backgroundColor = .white
        action.image = UIGraphicsImageRenderer(size: CGSize(width: imageSize, height: imageSize)).image { _ in
            UIImage(systemName: "multiply")!
                .withTintColor(.red, renderingMode: .alwaysOriginal)
                .draw(in: CGRect(x: -12, y: 0, width: imageSize, height: imageSize))
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
