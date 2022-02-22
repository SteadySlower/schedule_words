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

struct WordBookInput {
    let words: [WordInput]
    let createdAt: Date
    let didFinish = false
}
