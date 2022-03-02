//
//  CalendarService.swift
//  schedule_words
//
//  Created by JW Moon on 2022/03/02.
//

import Foundation

class CalendarService {
    
    // MARK: Stored Properties
    
    static let shared = CalendarService()
    
    private let plist = UserDefaults.standard
    
    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar
    }()
    
    let today: Date
    
    // MARK: Initializer
    
    init() {
        // 저장된 today가 없을 때
        guard let recorededToday = plist.object(forKey: "today") as? Date else {
            let today = Date()
            plist.set(Date() as NSDate, forKey: "today")
            self.today = today
            return
        }
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let isTodayValid = calendar.isDateInToday(recorededToday)
        
        if isTodayValid {
            self.today = recorededToday
        } else {
            let today = Date()
            plist.set(Date() as NSDate, forKey: "today")
            self.today = today
        }
    }
    
    // MARK: Methods
    
    // 날짜 비교
    func getDaysFromToday(date: Date) -> Int {
        return calendar.dateComponents([.day], from: date, to: today).day!
    }
    
    // 오늘 날짜 범위 리턴
    
    func getTodayRange() -> (dateFrom: Date, dateTo: Date) {
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        return (dateFrom: dateFrom, dateTo: dateTo)
    }
}
