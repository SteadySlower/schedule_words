//
//  WordBook.swift
//  schedule_words
//
//  Created by JW Moon on 2022/02/25.
//

import Foundation

enum WordBookStatus: Int16 {
    case study = 0, review, archived
}

struct WordBook {
    let id: String
    var words: [Word]
    let createdAt: Date
    let status: WordBookStatus
    let numOfReviews: Int
    
    // 오늘 만들어진 단어장인지 확인하는 property -> 새로운 단어는 오늘 단어장에 저장하기 위해서 필요
    var isToday: Bool {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar.isDateInToday(createdAt)
    }
    
    var isLastStudyDay: Bool {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let twoDaysBefore = calendar.date(byAdding: .day, value: -2, to: CalendarService.shared.today)!
        return calendar.isDate(createdAt, inSameDayAs: twoDaysBefore)
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
        self.status = WordBookStatus(rawValue: MO.status)!
        self.numOfReviews = Int(MO.numOfReviews)
    }
    
    mutating func prepareForTest() {
        let listingMode = UserSetting.shared.setting.testMode
        switch listingMode {
        case .onlyFail:
            resetTestFailResults()
        case .all:
            resetTestAllResults()
        }
    }
    
    private mutating func resetTestAllResults() {
        self.words = self.words.map({ word in
            var resetWord = word
            resetWord.testResult = .undefined
            return resetWord
        })
    }
    
    private mutating func resetTestFailResults() {
        self.words = self.words.map({ word in
            if word.testResult == .fail {
                var resetWord = word
                resetWord.testResult = .undefined
                return resetWord
            } else {
                return word
            }
        })
    }
}
