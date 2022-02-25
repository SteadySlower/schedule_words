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
    let id: String
    let spelling: String
    let meanings: [Meaning]
    var testResult: WordTestResult = .undefined
    
    init(MO: WordMO) {
        self.id = MO.objectID.uriRepresentation().absoluteString
        self.spelling = MO.spelling ?? ""
        let meaningMOs = MO.meanings!.array as! [MeaningMO]
        self.meanings = meaningMOs.map { meaningMO in
            Meaning(MO: meaningMO)
        }
        self.testResult = WordTestResult(rawValue: MO.testResult) ?? .undefined
    }
}

struct Meaning {
    let id: String
    let description: String
    
    init(MO: MeaningMO) {
        self.id = MO.objectID.uriRepresentation().absoluteString
        self.description = MO.content ?? ""
    }
}

