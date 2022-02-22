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
    var didChecked: Bool = false
    var testResult: WordTestResult = .undefined
    
    init(MO: WordMO) {
        self.id = MO.objectID.uriRepresentation().absoluteString
        self.spelling = MO.spelling ?? ""
        let meaningMOs = MO.meanings!.array as! [MeaningMO]
        self.meanings = meaningMOs.map { meaningMO in
            Meaning(MO: meaningMO)
        }
        self.didChecked = MO.didChecked
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

struct WordBook {
    let id: String
    var words: [Word]
    let createdAt: Date
    var didFinish: Bool
    
    // 오늘 만들어진 단어장인지 확인하는 property -> 새로운 단어는 오늘 단어장에 저장하기 위해서 필요
    var isToday: Bool {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar.isDateInToday(createdAt)
    }
    
    init(MO: WordBookMO) {
        self.id = MO.objectID.uriRepresentation().absoluteString
        self.createdAt = MO.createdAt!
        if let wordMOs = MO.words?.array as? [WordMO] {
            self.words = wordMOs.map { wordMO in
                Word(MO: wordMO)
            }
        } else {
            self.words = [Word]()
        }
        self.didFinish = MO.didFinish
    }
}
