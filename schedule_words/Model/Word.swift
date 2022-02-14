//
//  Word.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/26.
//

import Foundation
import CoreData

enum WordTestResult: Int16 {
    case undefined = 0, success, fail
}

struct Word {
    let id: NSManagedObjectID
    let spelling: String
    let meanings: [Meaning]
    var didChecked: Bool = false
    var testResult: WordTestResult = .undefined
}

struct Meaning {
    let id: NSManagedObjectID
    let description: String
}

struct WordBook {
    let id: NSManagedObjectID
    var words: [Word]
}
