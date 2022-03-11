//
//  TutorialController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/11.
//

import UIKit

enum TutorialType {
    case auto
    case manual
}

class TutorialController: UIViewController {
    
    // MARK: Properties
    
    let pageController = TutorialPageController()
    
    let type: TutorialType
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 5
        pc.tintColor = .gray
        pc.pageIndicatorTintColor = .white
        pc.currentPageIndicatorTintColor = .black
        pc.addTarget(self, action: #selector(pageChanged(sender:)), for: .valueChanged)
        return pc
    }()
    
    lazy var noShowCheckBox: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "square"), for: .normal)
        bt.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        bt.setTitle("다시 보지 않기", for: .normal)
        bt.setTitle("다시 보지 않기", for: .selected)
        bt.setTitleColor(.white, for: .normal)
        bt.setTitleColor(.white, for: .selected)
        bt.tintColor = .white
        bt.addTarget(self, action: #selector(checkBoxTapped(sender:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var closeButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("닫기", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    // MARK: LifeCycle
    
    init(type: TutorialType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageController.pageDelegate = self
        configureUI()
    }
    
    // MARK: Selectors
    
    @objc func pageChanged(sender: UIPageControl) {
        let index = sender.currentPage
        print("디버그: 페이지 바뀜 to \(index)")
    }
    
    @objc func checkBoxTapped(sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        view.backgroundColor = UIColor(displayP3Red: 0/256, green: 0/256, blue: 0/256, alpha: 0.5)
        
        guard let pcView = pageController.view else { return }
        view.addSubview(pcView)
        pcView.translatesAutoresizingMaskIntoConstraints = false
        pcView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        pcView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150).isActive = true
        pcView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        pcView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: pcView.bottomAnchor, constant: 20).isActive = true
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        
        view.addSubview(noShowCheckBox)
        noShowCheckBox.translatesAutoresizingMaskIntoConstraints = false
        noShowCheckBox.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20).isActive = true
        noShowCheckBox.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        noShowCheckBox.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        if type == .manual {
            noShowCheckBox.isHidden = true
        }
    }    
}

extension TutorialController: TutorialPageControllerDelegate {
    func pageChanged(index: Int) {
        pageControl.currentPage = index
    }
}
