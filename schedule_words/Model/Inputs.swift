//
//  Inputs.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/16.
//

import Foundation

struct WordInput {
    let spelling: String
    let meanings: [MeaningInput]
}

struct MeaningInput {
    let description: String
}

// TODO: 더미 데이터용
struct WordBookInput {
    let words: [WordInput]
    let createdAt: Date
}
