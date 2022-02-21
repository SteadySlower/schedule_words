//
//  HomeStat.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/28.
//

import Foundation

struct HomeStatus {
    let numOfStudyBooks: Int
    let numOfTotalStudyWords: Int
    let numOfTodoStudyWords: Int

    let numOfReviewBooks: Int
    let numOfTotalReviewWords: Int
    let numOfTodoReviewWords: Int

    init(studyWordBooks: [WordBook], reviewWordBooks: [WordBook]) {
        let utilities = Utilities()
        self.numOfStudyBooks = studyWordBooks.count
        self.numOfTotalStudyWords = utilities.countTotalWords(wordBooks: studyWordBooks)
        self.numOfTodoStudyWords = utilities.countTodoWords(wordBooks: studyWordBooks)
        
        self.numOfReviewBooks = reviewWordBooks.count
        self.numOfTotalReviewWords = utilities.countTotalWords(wordBooks: reviewWordBooks)
        self.numOfTodoReviewWords = utilities.countTodoWords(wordBooks: reviewWordBooks)
    }
}
