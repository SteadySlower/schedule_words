//
//  HomeStat.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/28.
//

import Foundation

struct HomeStatus {
    let numOfStudyBooks: Int
    let numOfStudyWords: Int
    var secondsOfStudyTime = TimeInterval(198)
    
    let numOfReviewBooks: Int
    let numOfReviewWords: Int
    var secondsOfReviewTime = TimeInterval(363)
    
    let studyWordBooks: [WordBook]
    let reviewWordBooks: [WordBook]
    
    init(studyWordBooks: [WordBook], reviewWordBooks: [WordBook]) {
        self.studyWordBooks = studyWordBooks
        self.reviewWordBooks = reviewWordBooks
        self.numOfStudyBooks = studyWordBooks.count
        self.numOfReviewBooks = reviewWordBooks.count
        self.numOfStudyWords = Utilities().countWords(wordBooks: studyWordBooks)
        self.numOfReviewWords = Utilities().countWords(wordBooks: reviewWordBooks)
    }
}
