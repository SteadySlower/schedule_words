//
//  Word.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation

struct Word {
    let id = UUID()
    let spelling: String
    let meanings: [Meaning]
}

struct Meaning {
    let id = UUID()
//    let wordId: UUID
    let description: String
}

struct WordBook {
    let id = UUID()
    let words: [Word]
}
