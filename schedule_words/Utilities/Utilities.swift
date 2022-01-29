//
//  Utilities.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/28.
//

import Foundation

class Utilities {
    
    // 날짜 비교
    func getDaysFromToday(date: Date) -> Int {
        let today = Date()
        return Calendar.current.dateComponents([.day], from: date, to: today).day!
    }
    
    // 단어장 리스트에 모든 단어 세기
    func countWords(wordBooks: [WordBook]) -> Int {
        var result = 0
        for wordBook in wordBooks {
            result += wordBook.words.count
        }
        return result
    }
}
