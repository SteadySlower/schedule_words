//
//  ListTestViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

struct ListTestViewModel {
    
    private let wordBook: WordBook
    
    var undefinedWords: [Word]
    private var successWords: [Word]
    private var failWords: [Word]
    
    init(wordBook: WordBook) {
        self.wordBook = wordBook
        self.undefinedWords = wordBook.words
        self.successWords = [Word]()
        self.failWords = [Word]()
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
}
