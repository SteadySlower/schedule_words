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
    
    let tableView = UITableView()
    
    var viewModel = HomeViewModel()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureHomeStatusView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: Selectors
    
    @objc func showWordInputController() {
        let input = WordInputController(homeViewController: self)
        input.modalPresentationStyle = .overFullScreen
        self.present(input, animated: true, completion: nil)
    }
    
    @objc func showSettingController() {
        let setting = SettingContoller()
        present(setting, animated: true, completion: nil)
    }
    
    // FIXME: DEV
    @objc func showCalendarController() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let datePickerController = DatePickerViewController()
        actionSheet.setValue(datePickerController, forKey: "contentViewController")

        let delay = UIAlertAction(title: "날짜 변경", style: .default) { _ in
            let date = datePickerController.datePicker.date
            CalendarService.shared.chanageToday(date: date)
            self.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        actionSheet.addAction(delay)
        actionSheet.addAction(cancel)

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func dayPlusOne() {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let today = CalendarService.shared.today
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        CalendarService.shared.chanageToday(date: tomorrow)
        reloadData()
    }
    
    // MARK: Helpers
    
    func reloadData() {
        viewModel.updateViewModel()
        configureHomeStatusView()
        tableView.reloadData()
    }
    
    private func configureUI() {
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
    
    private func configureHomeStatusView() {
        statusView.homeStatus = viewModel.homeStatus
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "홈화면"
        let plusImage = UIImage(systemName: "plus")
        let settingImage = UIImage(systemName: "gear")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: plusImage, style: .plain, target: self, action: #selector(showWordInputController))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: settingImage, style: .plain, target: self, action: #selector(showSettingController))
        
        // FIXME: DEV
        let calendarImage = UIImage(systemName: "calendar")
        let calendarBarItem = UIBarButtonItem.init(image: calendarImage, style: .plain, target: self, action: #selector(dayPlusOne))
        self.navigationItem.rightBarButtonItems?.append(calendarBarItem)
    }
    
    private func showActionSheet(wordBook: WordBook) {
        let actionSheetTitle = viewModel.actionSheetTitle(of: wordBook)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .heavy), NSAttributedString.Key.foregroundColor: UIColor.blue]
        let titleAttrString = NSMutableAttributedString(string: actionSheetTitle, attributes: attributes)
        actionSheet.setValue(titleAttrString, forKey: "attributedTitle")
        
        let studyAction = UIAlertAction(title: "공부 하기", style: .default) { [weak self] _ in
            let study = StudyListController(wordBook: wordBook)
            self?.navigationController?.pushViewController(study, animated: true)
        }
        
        let testAction = UIAlertAction(title: "테스트 하기", style: .default) { [weak self] _ in
            let test = TestListController(wordBook: wordBook)
            self?.navigationController?.pushViewController(test, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        actionSheet.addAction(studyAction)
        actionSheet.addAction(testAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension HomeController: UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? HomeListCell else { return UITableViewCell() }
        guard let wordBook = viewModel.wordBookForHomeCell(of: indexPath) else { return UITableViewCell() }
        cell.viewModel = HomeCellViewModel(wordBook: wordBook)
        return cell
    }
}

// MARK: UITableViewDelegate

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? HomeListCell else { return }
        guard let wordBook = cell.viewModel?.wordBook else { return }
        
        if indexPath.section == 0 {
            showActionSheet(wordBook: wordBook)
        } else if indexPath.section == 1 {
            let test = TestListController(wordBook: wordBook)
            self.navigationController?.pushViewController(test, animated: true)
        }
    }
}


