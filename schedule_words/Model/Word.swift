//
//  Word.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

enum WordTestResult: Int16 {
    case undefined = 0, success, fail
}

struct Word {
    let id = UUID()
    let spelling: String
    let meanings: [Meaning]
    var didChecked: Bool = false
    var testResult: WordTestResult = .undefined
    //let createdAt: Date
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
    // var next
}
