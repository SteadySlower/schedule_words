//
//  Inputs.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/16.
//

import Foundation

//⭐️ 만들고 커밋해!

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
