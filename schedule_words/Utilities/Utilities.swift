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
    
    // 오늘 날짜 범위 리턴
    
    func getTodayRange() -> (dateFrom: Date, dateTo: Date) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        
        return (dateFrom: dateFrom, dateTo: dateTo)
    }
    
    // 단어장 리스트에 모든 단어 세기
    func countWords(wordBooks: [WordBook]) -> Int {
        var result = 0
        for wordBook in wordBooks {
            result += wordBook.words.count
        }
        return result
    }
    
    // Word(spelling) 입력 형식적 조건 만족하는지 확인
    func validateWordInput(input: String) -> Bool {
        let arr = Array(input)
        let pattern = "/^[a-zA-Z0-9]*$/"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .allowCommentsAndWhitespace) {
            var index = 0
            while index < arr.count {
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
    
    // 의미 입력 형식적 조건 만족하는지 확인
    func validateMeaningInput(input: String) -> Bool {
        let arr = Array(input)
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣ0-9\\s]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .allowCommentsAndWhitespace) {
            var index = 0
            while index < arr.count {
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
}
