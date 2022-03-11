//
//  TutorialController.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/04.
//

import UIKit

protocol TutorialPageControllerDelegate: AnyObject {
    func pageChanged(index: Int)
}

class TutorialPageController: UIPageViewController {
    
    weak var pageDelegate: TutorialPageControllerDelegate?
    
    lazy var firstVC: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        return vc
    }()
    
    let secondVC: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        return vc
    }()
    
    let thirdVC: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        return vc
    }()
    
    lazy var VCs = [
        firstVC,
        secondVC,
        thirdVC,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstvc = VCs.first {
            self.setViewControllers([firstvc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func configureUI() {
    }
    
    private func configureTutorials() {
        
    }

}

extension TutorialPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = VCs.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        
        pageDelegate?.pageChanged(index: previousIndex)
        
        return VCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = VCs.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == VCs.count { return nil }
        
        pageDelegate?.pageChanged(index: nextIndex)
              
        return VCs[nextIndex]
    }
}
