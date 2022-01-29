//
//  Utilities.swift
//  schedule_words
//
//  Created by JW Moon on 2022/01/28.
//

import Foundation

class Utilities {
    func getDaysFromToday(date: Date) -> Int {
        let today = Date()
        return Calendar.current.dateComponents([.day], from: date, to: today).day!
    }
}
