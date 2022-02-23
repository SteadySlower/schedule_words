//
//  ListStudyViewModel.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/29.
//

import Foundation

struct StudyListViewModel {
    
    var wordBook: WordBook
    
    init(wordBook: WordBook) {
        self.wordBook = wordBook
        self.wordBook.words.shuffle()
    }
    
    var numOfCells: Int {
        return wordBook.words.count
    }

}
