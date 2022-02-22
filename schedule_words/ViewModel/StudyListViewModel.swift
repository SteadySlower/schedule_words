//
//  ListStudyViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import Foundation

import Foundation

enum StudyListResult {
    case check(index: Int)
    case uncheck(index: Int)
}

struct StudyListViewModel {
    
    var wordBook: WordBook
    
    private var checkResults: [StudyListResult]
        // 테스트 결과를 저장해두고 실행취소할 때 사용한다.
    
    init(wordBook: WordBook) {
        self.wordBook = wordBook
        self.checkResults = [StudyListResult]()
        
    }
    
    var numOfCells: Int {
        return wordBook.words.count
    }
    
    mutating func moveWordToChecked(checked: Word) -> Int? {
        let index = wordBook.words.firstIndex { word in
            return word.id == checked.id
        }
        
        if let index = index {
            wordBook.words[index].didChecked = true
            checkResults.append(.check(index: index))
            return index
        } else {
            return nil
        }
    }
    
    mutating func moveWordToUnchecked(unchecked: Word) -> Int? {
        let index = wordBook.words.firstIndex { word in
            return word.id == unchecked.id
        }
        
        if let index = index {
            wordBook.words[index].didChecked = false
            checkResults.append(.uncheck(index: index))
            return index
        } else {
            return nil
        }
    }
    
    mutating func undo() {
        guard let latest = checkResults.popLast() else { return }
        
        switch latest {
        case .check(let index):
            wordBook.words[index].didChecked = false
            return
        case .uncheck(let index):
            wordBook.words[index].didChecked = true
            return
        }
    }
    
    func updateDidCheck() {
        // TODO: false 일 경우 에러 처리
        wordBook.words.forEach { word in
            _ = WordService.shared.updateDidCheck(word: word)
        }
    }
}
