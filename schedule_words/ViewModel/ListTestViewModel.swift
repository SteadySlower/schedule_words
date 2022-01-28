//
//  ListTestViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

enum ListTestResult {
    case success(index: Int)
    case fail(index: Int)
}

struct ListTestViewModel {
    
    private let wordBook: WordBook
    
    var undefinedWords: [Word]
    private var successWords: [Word]
    private var failWords: [Word]
    private var testResults: [ListTestResult]
        // 테스트 결과를 저장해두고 실행취소할 때 사용한다.
    
    init(wordBook: WordBook) {
        self.wordBook = wordBook
        self.undefinedWords = wordBook.words
        self.successWords = [Word]()
        self.failWords = [Word]()
        self.testResults = [ListTestResult]()
    }
    
    var numOfCells: Int {
        return undefinedWords.count
    }
    
    var scores: (undefined: Int, success: Int, fail: Int) {
        let undefined = undefinedWords.count
        let success = successWords.count
        let fail = failWords.count
        return (undefined: undefined, success: success, fail: fail)
    }
    
    mutating func moveWordToSuccess(word: Word) {
        let index = undefinedWords.firstIndex { undefined in
            undefined.id == word.id
        }
        
        if let index = index {
            successWords.append(word)
            undefinedWords.remove(at: index)
            testResults.append(.success(index: index))
        }
    }
    
    mutating func moveWordToFail(word: Word) {
        let index = undefinedWords.firstIndex { undefined in
            undefined.id == word.id
        }
        
        if let index = index {
            failWords.append(word)
            undefinedWords.remove(at: index)
            testResults.append(.fail(index: index))
        }
    }
    
    mutating func undo() -> Int? {
        guard let latest = testResults.popLast() else { return  nil}
        
        switch latest {
        case .success(let index):
            guard let word = successWords.popLast() else { return nil }
            undefinedWords.insert(word, at: index)
            return index
        case .fail(let index):
            guard let word = failWords.popLast() else { return nil }
            undefinedWords.insert(word, at: index)
            return index
        }
    }
}
