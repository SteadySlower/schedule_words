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
    
    lazy var pageVCs: [TutorialContentController] = {
       var controllers = [TutorialContentController]()
        for i in 1...5 {
            let tutorialImage = #imageLiteral(resourceName: "tutorial_image_1")
            let controller = TutorialContentController(image: tutorialImage)
            controllers.append(controller)
        }
        return controllers
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // FIXME: dataSource를 한 단계 위의 컨트롤러로 옮기기
        self.dataSource = self
        if let firstvc = pageVCs.first {
            self.setViewControllers([firstvc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // TODO: complete the functions
    private func configureUI() {
        
    }
    
    private func configureTutorials() {
        
    }

}

extension TutorialPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let contentController = viewController as? TutorialContentController else { return nil }
        guard let index = pageVCs.firstIndex(of: contentController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        
        pageDelegate?.pageChanged(index: previousIndex)
        
        return pageVCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let contentController = viewController as? TutorialContentController else { return nil }
        guard let index = pageVCs.firstIndex(of: contentController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == pageVCs.count { return nil }
        
        pageDelegate?.pageChanged(index: nextIndex)
              
        return pageVCs[nextIndex]
    }
}
