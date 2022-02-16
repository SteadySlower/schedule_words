//
//  ListTestViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

fileprivate enum TestListResult {
    case success(index: Int)
    case fail(index: Int)
}

struct TestListViewModel {
    
    private var wordBook: WordBook {
        didSet {
            words = wordBook.words.filter({ word in
                word.testResult == .undefined
            })
        }
    }
    
    var words: [Word]
    
    private var testResults: [TestListResult]
        // 테스트 결과를 저장해두고 실행취소할 때 사용한다.
    
    init(wordBook: WordBook) {
        self.wordBook = wordBook
        self.words = wordBook.words.filter({ word in
            word.testResult == .undefined
        })
        self.testResults = [TestListResult]()
    }
    
    var numOfCells: Int {
        return words.count
    }
    
    var scores: (undefined: Int, success: Int, fail: Int) {
        let undefined = wordBook.words.filter { word in
            return word.testResult == .undefined
        }.count
        let success = wordBook.words.filter { word in
            return word.testResult == .success
        }.count
        let fail = wordBook.words.filter { word in
            return word.testResult == .fail
        }.count
        return (undefined: undefined, success: success, fail: fail)
    }
    
    mutating func moveWordToSuccess(success: Word) {
        let index = wordBook.words.firstIndex { word in
            success.id == word.id
        }
        
        if let index = index {
            wordBook.words[index].testResult = .success
            testResults.append(.success(index: index))
        }
    }
    
    mutating func moveWordToFail(fail: Word) {
        let index = wordBook.words.firstIndex { word in
            fail.id == word.id
        }
        
        if let index = index {
            wordBook.words[index].testResult = .fail
            testResults.append(.fail(index: index))
        }
    }
    
    mutating func undo() -> Int? {
        guard let latest = testResults.popLast() else { return  nil}
        
        switch latest {
        case .success(let index):
            wordBook.words[index].testResult = .undefined
            return index
        case .fail(let index):
            wordBook.words[index].testResult = .undefined
            return index
        }
    }
}
