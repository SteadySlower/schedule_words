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
    let wordBookID: String
    
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
        
        self.wordBookID = wordBook.id
    }
    
    var numOfCells: Int {
        return displayingWords.count
    }
    
    // TODO: 에러 처리
    func deleteWord(word: Word) {
        _ = WordService.shared.deleteWord(id: word.id)
    }
    
    func resetDisplayWords() {
        guard let editedWordBook = WordService.shared.fetchWordBookByID(id: wordBookID) else { return }
        
        let studyMode = UserSetting.shared.setting.studyMode
        
        switch studyMode {
        case .onlyFail:
            self.displayingWords = editedWordBook.words.filter({ word in
                word.testResult != .success
            })
        case .all:
            self.displayingWords = editedWordBook.words
        }
        
        let wordsOrder = UserSetting.shared.setting.studyWordsOrder
        
        if wordsOrder == .random {
            displayingWords.shuffle()
        }
    }

}
