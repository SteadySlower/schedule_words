//
//  HomeStat.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/28.
//

import Foundation

struct HomeStat {
    let numOfStudyBooks: Int
    let numOfStudyWords: Int
    let secondsOfStudyTime: TimeInterval
    
    let numOfReviewBooks: Int
    let numOfReviewWords: Int
    let secondsOfReviewTime: TimeInterval
    
    let studyWordBooks: [WordBook]
    let reviewWordBooks: [WordBook]
}
