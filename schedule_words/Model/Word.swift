//
//  Word.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

enum WordTestResult {
    case undefined, success, fail
}

struct Word {
    let id = UUID()
    let spelling: String
    let meanings: [Meaning]
    var didChecked: Bool = false
    var testResult: WordTestResult = .undefined
}

struct Meaning {
    let id = UUID()
//    let wordId: UUID
    let description: String
}

struct WordBook {
    let id = UUID()
    var words: [Word]
    let createdAt: Date
}
