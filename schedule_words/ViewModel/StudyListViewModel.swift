//
//  ListStudyViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import Foundation
import UIKit

class StudyListViewModel {
    
    var displayingWords: [Word]
    
    init(wordBook: WordBook) {
        let studyMode = UserSetting.shared.setting.studyMode
        
        switch studyMode {
        case .onlyFail:
            self.displayingWords = wordBook.words.filter({ word in
                word.testResult != .success
            })
        case .all:
            self.displayingWords = wordBook.words
        }
        
        let wordsOrder = UserSetting.shared.setting.studyWordsOrder
        
        if wordsOrder == .random {
            displayingWords.shuffle()
        }
    }
    
    var numOfCells: Int {
        return displayingWords.count
    }
    
    func editWord() {
        
    }
    
    func deleteWord() {
        
    }

}
