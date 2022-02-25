//
//  ListTestViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

fileprivate enum TestListResult {
    case success(wordBookIndex: Int, displayIndex: Int)
    case fail(wordBookIndex: Int, displayIndex: Int)
}

class TestListViewModel {
    
    private var wordBook: WordBook
    
    var displayingWords: [Word]
    
    private var testResults: [TestListResult]
        // 테스트 결과를 저장해두고 실행취소할 때 사용한다.
    
    init(wordBook: WordBook) {
        self.wordBook = wordBook
        self.wordBook.prepareForTest()
        
        self.displayingWords = self.wordBook.words.filter({ word in
            word.testResult == .undefined
        })
        
        let wordsOrder = UserSetting.shared.setting.testWordsOrder
        
        if wordsOrder == .random {
            self.displayingWords.shuffle()
        }
        
        self.testResults = [TestListResult]()
    }
    
    var canFinish: Bool {
        switch wordBook.status {
        case .review:
            return displayingWords.isEmpty
        case .study:
            if wordBook.isLastStudyDay {
                return displayingWords.isEmpty
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    var numOfCells: Int {
        return displayingWords.count
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
    
    var undoButtonIsHidden: Bool {
        return testResults.isEmpty ? true : false
    }
    
    func moveWordToSuccess(success: Word) {
        let wordBookIndex = wordBook.words.firstIndex { word in
            success.id == word.id
        }
        
        let displayIndex = displayingWords.firstIndex { word in
            success.id == word.id
        }
        
        if let wordBookIndex = wordBookIndex, let displayIndex = displayIndex {
            wordBook.words[wordBookIndex].testResult = .success
            displayingWords.remove(at: displayIndex)
            testResults.append(.success(wordBookIndex: wordBookIndex, displayIndex: displayIndex))
        }
    }
    
    func moveWordToFail(fail: Word) {
        let wordBookIndex = wordBook.words.firstIndex { word in
            fail.id == word.id
        }
        
        let displayIndex = displayingWords.firstIndex { word in
            fail.id == word.id
        }
        
        if let wordBookIndex = wordBookIndex, let displayIndex = displayIndex {
            wordBook.words[wordBookIndex].testResult = .fail
            displayingWords.remove(at: displayIndex)
            testResults.append(.fail(wordBookIndex: wordBookIndex, displayIndex: displayIndex))
        }
    }
    
    func undo() -> Int? {
        // TODO: Error throw 하도록 수정
        guard let latest = testResults.popLast() else { return nil }
        
        switch latest {
        case .success(let wordBookIndex, let displayIndex):
            wordBook.words[wordBookIndex].testResult = .undefined
            let word = wordBook.words[wordBookIndex]
            displayingWords.insert(word, at: displayIndex)
            return displayIndex
        case .fail(let wordBookIndex, let displayIndex):
            wordBook.words[wordBookIndex].testResult = .undefined
            let word = wordBook.words[wordBookIndex]
            displayingWords.insert(word, at: displayIndex)
            return displayIndex
        }
    }
    
    func updateTestResult() {
        // TODO: false 일 경우 에러 처리
        wordBook.words.forEach { word in
            _ = WordService.shared.updateTestResult(word: word)
        }
    }
}
