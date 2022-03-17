//
//  TutorialViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/17.
//

import Foundation

class TutorialViewModel {
    
    var currentIndex: Int = 0
    
    private let pageVCs: [TutorialContentController] = {
       var controllers = [TutorialContentController]()
        for pageNumber in 1...8 {
            let controller = TutorialContentController(pageNumber: pageNumber)
            controllers.append(controller)
        }
        return controllers
    }()
    
    var firstVC: TutorialContentController? {
        return pageVCs.first
    }
    
    var previousVC: TutorialContentController? {
        let previousIndex = currentIndex - 1
        
        if previousIndex < 0 { return nil }
        
        currentIndex = previousIndex
        
        return pageVCs[currentIndex]
    }
    
    var nextVC: TutorialContentController? {
        let nextIndex = currentIndex + 1
        
        if nextIndex == pageVCs.count { return nil }
        
        currentIndex = nextIndex
        
        return pageVCs[currentIndex]
    }
    
    func getContentController(of index: Int) -> TutorialContentController? {
        guard index >= 0 && index < pageVCs.count else { return nil }
        
        currentIndex = index
        
        return pageVCs[currentIndex]
    }
}
